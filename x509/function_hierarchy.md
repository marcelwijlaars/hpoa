# X509.c Function Call Hierarchy

## Main Entry Points
* `FUN_1000ca0c` - Main validation entry point
  * Calls `X509_parse_signed_file`
  * Calls `X509_certificate_compare`
  * Calls `FUN_1000da30` (Initialize message digest)
  * Calls `X509_verify_signature`
  * Calls `FUN_1000de80` (Cleanup)

## X.509 Certificate Operations
* `PEM_read_bio_X509` - Read X.509 certificate
  * Calls `PEM_ASN1_read_bio`

* `X509_add_cert_to_stack` (FUN_1000b770) - Add certificate to stack
  * Calls `BIO_new`/`BIO_puts`
  * Calls `PEM_read_bio_X509`
  * Calls `BIO_free`
  * Calls `sk_new`/`sk_push`

* `PEM_read_bio_X509_AUX` (FUN_1000b9f4) - Read certificate with auxiliary data
  * Calls `BIO_new`/`BIO_puts`
  * Calls `PEM_read_bio_X509`
  * Calls `BIO_free`

* `X509_get_embedded_cert` (FUN_1000bac8) - Get embedded certificate
  * Calls `BIO_new`/`BIO_s_mem`
  * Calls `FUN_1000cd38` (get embedded signing cert)
  * Calls `BIO_puts`
  * Calls `PEM_read_bio_X509`
  * Calls `BIO_free`

* `X509_certificate_compare` (FUN_1000ddd4) - Compare certificates
  * Calls `X509_cmp`

* `X509_verify_signature` (FUN_1000dc8c) - Verify certificate signature
  * Calls `X509_get_pubkey`
  * Calls `EVP_VerifyFinal`

* `X509_parse_signed_file` (FUN_1000d6e0) - Parse signed file with certificates
  * Calls `FUN_1000b510` (get filename)
  * Calls `FUN_1000b5f0` (set offset)
  * Calls `FUN_1000ce94` (find block length)
  * Calls `FUN_1000b6b0` (set length)
  * Calls `X509_extract_fingerprint_block`

* `X509_extract_fingerprint_block` (FUN_1000d368) - Extract fingerprint block
  * Calls `FUN_1000c6f4` (memory allocation)
  * Calls `FUN_1000b538` (set fingerprint)
  * Calls `FUN_1000c7dc` (memory free)
  * Calls `X509_split_certificate_chain`
  * Calls `FUN_1000d4dc` (parse fingerprint)

* `X509_split_certificate_chain` (FUN_1000cff0) - Split certificate chain
  * Calls `FUN_1000c6f4` (memory allocation)
  * Calls `FUN_1000d22c` (append PEM buffer)
  * Calls `PEM_read_bio_X509_AUX`
  * Calls `X509_add_cert_to_stack`
  * Calls `FUN_1000c7dc` (memory free)

## Message Digest Functions
* `EVP_get_digestbytype` (FUN_1000d988) - Select message digest algorithm
  * Calls `FIPS_evp_sha1`/`FIPS_evp_sha256`/`FIPS_evp_sha512`

* `FUN_1000da30` - Initialize message digest
  * Calls `OPENSSL_add_all_algorithms_noconf`
  * Calls `FIPS_md_ctx_create`
  * Calls `EVP_get_digestbytype`
  * Calls `FIPS_digestinit`

* `FUN_1000dae4` - Update message digest with file content
  * Calls `FUN_1000c6f4` (memory allocation)
  * Calls `FIPS_digestupdate`
  * Calls `FUN_1000c7dc` (memory free)

## Memory Management Functions
* `FUN_1000c6f4` - Memory allocation wrapper
  * Calls `calloc`
  * Calls `memset`

* `FUN_1000c7dc` - Memory free wrapper
  * Calls `free`

## String Handling Functions
* `trimSpaces` - Remove leading spaces
  * Calls `strlen`
  * Calls `truncateSpaces`

* `truncateSpaces` - Remove trailing spaces
  * Calls `strlen`

* `FUN_1000be80` - Convert to lowercase
  * No external calls

## Base64 Functions
* `FUN_1000c09c` - Base64 encoding helper
  * No external calls

* `FUN_1000bf58` - Base64 encode
  * Calls `FUN_1000c09c`
  * Calls `memset`/`memcpy`

* `FUN_1000c18c` - Base64 decode
  * Calls `FUN_1000c6f4`
  * Calls `FUN_1000c384`
  * Calls `FUN_1000c488`
  * Calls `memcpy`

* `FUN_1000c384` - Base64 character conversion
  * No external calls

* `FUN_1000c488` - Base64 block decode
  * Calls `FUN_1000c384`

## Cleanup Functions
* `FUN_1000de80` - Close and cleanup
  * Calls `FUN_1000c7dc`
  * Calls `FUN_1000e38c`

* `FUN_1000e38c` - Close signed hash
  * Calls `memset`
  * Calls `FUN_1000c7dc`

* `FUN_1000ce10` - Release embedded signing cert
  * Calls `memset`
  * Calls `FUN_1000c7dc`

## Utility Functions
* `FUN_1000bc00` - String to boolean conversion
  * Calls `calloc`
  * Calls `FUN_1000c6f4`
  * Calls `FUN_1000be80`
  * Calls `trimSpaces`
  * Calls `FUN_1000c7dc`

* `FUN_1000bdd4` - Int to boolean string conversion
  * No external calls

* `FUN_1000be20` - Int to string conversion
  * Calls `sprintf`

* `FUN_1000ce94` - Find block length
  * Calls `memset`
  * Calls `strstr`
  * Calls `strlen`
  * Calls `strtol`

* `FUN_1000d22c` - Append to PEM buffer
  * Calls `strlen`
  * Calls `strcat`
  * Calls `realloc`

* `FUN_1000d4dc` - Parse fingerprint
  * Calls `calloc`
  * Calls `FUN_1000c6f4`
  * Calls `strtok`
  * Calls `strstr`
  * Calls `FUN_1000e064` (set private key ID)
  * Calls `FUN_1000e410` (set hash type)
  * Calls `FUN_1000e2b4` (init signed hash)
  * Calls `FUN_1000c18c` (base64 decode)
  * Calls `FUN_1000c7dc`

