;; Legal Department Verification Contract
;; This contract validates legal departments and their authorized personnel

(define-data-var admin principal tx-sender)

;; Map of verified legal departments
(define-map legal-departments
  { department-id: (string-ascii 64) }
  {
    name: (string-ascii 100),
    verified: bool,
    verification-date: uint
  }
)

;; Map of authorized personnel for each department
(define-map authorized-personnel
  {
    department-id: (string-ascii 64),
    personnel-id: (string-ascii 64)
  }
  {
    name: (string-ascii 100),
    role: (string-ascii 50),
    authorized: bool,
    authorization-date: uint
  }
)

;; Register a new legal department
(define-public (register-department (department-id (string-ascii 64)) (name (string-ascii 100)))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u403))
    (asserts! (is-none (map-get? legal-departments { department-id: department-id })) (err u409))
    (ok (map-set legal-departments
      { department-id: department-id }
      {
        name: name,
        verified: false,
        verification-date: u0
      }
    ))
  )
)

;; Verify a legal department
(define-public (verify-department (department-id (string-ascii 64)))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u403))
    (asserts! (is-some (map-get? legal-departments { department-id: department-id })) (err u404))
    (ok (map-set legal-departments
      { department-id: department-id }
      (merge (unwrap-panic (map-get? legal-departments { department-id: department-id }))
        {
          verified: true,
          verification-date: block-height
        }
      )
    ))
  )
)

;; Add authorized personnel to a department
(define-public (add-personnel
    (department-id (string-ascii 64))
    (personnel-id (string-ascii 64))
    (name (string-ascii 100))
    (role (string-ascii 50)))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u403))
    (asserts! (is-some (map-get? legal-departments { department-id: department-id })) (err u404))
    (asserts! (is-none (map-get? authorized-personnel { department-id: department-id, personnel-id: personnel-id })) (err u409))
    (ok (map-set authorized-personnel
      { department-id: department-id, personnel-id: personnel-id }
      {
        name: name,
        role: role,
        authorized: true,
        authorization-date: block-height
      }
    ))
  )
)

;; Check if a department is verified
(define-read-only (is-department-verified (department-id (string-ascii 64)))
  (match (map-get? legal-departments { department-id: department-id })
    dept (ok (get verified dept))
    (err u404)
  )
)

;; Check if personnel is authorized
(define-read-only (is-personnel-authorized (department-id (string-ascii 64)) (personnel-id (string-ascii 64)))
  (match (map-get? authorized-personnel { department-id: department-id, personnel-id: personnel-id })
    person (ok (get authorized person))
    (err u404)
  )
)

;; Transfer admin rights
(define-public (transfer-admin (new-admin principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u403))
    (ok (var-set admin new-admin))
  )
)
