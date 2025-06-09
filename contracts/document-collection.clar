;; Document Collection Contract
;; This contract manages the collection of electronic discovery documents

(define-data-var admin principal tx-sender)

;; Map of document collections
(define-map document-collections
  { collection-id: (string-ascii 64) }
  {
    case-id: (string-ascii 64),
    department-id: (string-ascii 64),
    created-by: principal,
    creation-date: uint,
    status: (string-ascii 20),
    document-count: uint,
    hash-root: (buff 32)
  }
)

;; Map of documents in collections
(define-map documents
  {
    collection-id: (string-ascii 64),
    document-id: (string-ascii 64)
  }
  {
    name: (string-ascii 100),
    file-type: (string-ascii 10),
    hash: (buff 32),
    size: uint,
    metadata: (string-utf8 500),
    collected-at: uint
  }
)

;; Create a new document collection
(define-public (create-collection
    (collection-id (string-ascii 64))
    (case-id (string-ascii 64))
    (department-id (string-ascii 64))
    (hash-root (buff 32)))
  (begin
    (asserts! (is-none (map-get? document-collections { collection-id: collection-id })) (err u409))
    (ok (map-set document-collections
      { collection-id: collection-id }
      {
        case-id: case-id,
        department-id: department-id,
        created-by: tx-sender,
        creation-date: block-height,
        status: "created",
        document-count: u0,
        hash-root: hash-root
      }
    ))
  )
)

;; Add a document to a collection
(define-public (add-document
    (collection-id (string-ascii 64))
    (document-id (string-ascii 64))
    (name (string-ascii 100))
    (file-type (string-ascii 10))
    (hash (buff 32))
    (size uint)
    (metadata (string-utf8 500)))
  (let ((collection (map-get? document-collections { collection-id: collection-id })))
    (asserts! (is-some collection) (err u404))
    (asserts! (is-eq (get status (unwrap-panic collection)) "created") (err u403))
    (asserts! (is-none (map-get? documents { collection-id: collection-id, document-id: document-id })) (err u409))
    (map-set documents
      { collection-id: collection-id, document-id: document-id }
      {
        name: name,
        file-type: file-type,
        hash: hash,
        size: size,
        metadata: metadata,
        collected-at: block-height
      }
    )
    (ok (map-set document-collections
      { collection-id: collection-id }
      (merge (unwrap-panic collection)
        { document-count: (+ (get document-count (unwrap-panic collection)) u1) }
      )
    ))
  )
)

;; Finalize a document collection
(define-public (finalize-collection (collection-id (string-ascii 64)))
  (let ((collection (map-get? document-collections { collection-id: collection-id })))
    (asserts! (is-some collection) (err u404))
    (asserts! (is-eq (get created-by (unwrap-panic collection)) tx-sender) (err u403))
    (asserts! (is-eq (get status (unwrap-panic collection)) "created") (err u403))
    (ok (map-set document-collections
      { collection-id: collection-id }
      (merge (unwrap-panic collection)
        { status: "finalized" }
      )
    ))
  )
)

;; Get collection details
(define-read-only (get-collection (collection-id (string-ascii 64)))
  (map-get? document-collections { collection-id: collection-id })
)

;; Get document details
(define-read-only (get-document (collection-id (string-ascii 64)) (document-id (string-ascii 64)))
  (map-get? documents { collection-id: collection-id, document-id: document-id })
)

;; Transfer admin rights
(define-public (transfer-admin (new-admin principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u403))
    (ok (var-set admin new-admin))
  )
)
