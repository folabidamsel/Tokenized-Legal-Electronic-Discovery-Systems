# Tokenized Legal Electronic Discovery System

This project implements a tokenized legal electronic discovery system using Clarity smart contracts. The system facilitates the management of electronic discovery processes in legal proceedings through a series of interconnected smart contracts.

## Overview

The system consists of five main components:

1. **Legal Department Verification**: Validates legal departments and their authorized personnel
2. **Document Collection**: Manages the collection of electronic discovery documents
3. **Review Coordination**: Coordinates document review processes
4. **Privilege Management**: Manages privileged documents
5. **Production Tracking**: Tracks document production

## Contracts

### Legal Department Verification

This contract handles the verification of legal departments and their authorized personnel. It maintains records of verified departments and the personnel authorized to work with them.

Key functions:
- `register-department`: Register a new legal department
- `verify-department`: Verify a legal department
- `add-personnel`: Add authorized personnel to a department
- `is-department-verified`: Check if a department is verified
- `is-personnel-authorized`: Check if personnel is authorized

### Document Collection

This contract manages the collection of electronic discovery documents. It tracks document collections and the individual documents within them.

Key functions:
- `create-collection`: Create a new document collection
- `add-document`: Add a document to a collection
- `finalize-collection`: Finalize a document collection
- `get-collection`: Get collection details
- `get-document`: Get document details

### Review Coordination

This contract coordinates document review processes. It manages review batches and the documents within them.

Key functions:
- `create-batch`: Create a new review batch
- `add-document-to-batch`: Add a document to a review batch
- `update-document-review`: Update document review status
- `complete-batch`: Complete a review batch
- `get-batch`: Get batch details
- `get-document-review`: Get document review details

### Privilege Management

This contract manages privileged documents. It maintains logs of privileged documents and their review status.

Key functions:
- `create-privilege-log`: Create a new privilege log
- `mark-privileged`: Mark a document as privileged
- `review-privileged`: Review a privileged document
- `get-privilege-log`: Get privilege log details
- `get-privileged-document`: Get privileged document details
- `is-document-privileged`: Check if a document is privileged

### Production Tracking

This contract tracks document production. It manages production batches and the documents within them.

Key functions:
- `create-production-batch`: Create a new production batch
- `add-document-to-production`: Add a document to a production batch
- `finalize-production`: Finalize a production batch
- `mark-documents-produced`: Mark documents as produced
- `get-production-batch`: Get production batch details
- `get-production-document`: Get production document details

## Usage

To use this system, deploy the contracts in the following order:

1. Legal Department Verification
2. Document Collection
3. Review Coordination
4. Privilege Management
5. Production Tracking

After deployment, you can interact with the contracts using their public functions.

## Testing

Tests for the contracts are written using Vitest. Run the tests with:

\`\`\`bash
npm test
\`\`\`

## License

This project is licensed under the MIT License.
