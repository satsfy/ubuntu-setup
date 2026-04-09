# GPG + `crypt` Helper

This is a copy-paste guide to create, transfer, and use a GPG key with the local `crypt` script.

## 1) Create a GPG key (source machine)

```bash
gpg --full-generate-key
```

Suggested options:
- Key type: `RSA and RSA`
- Key size: `4096`
- Expiration: `1y` (or `0` for no expiration)

List keys and copy your key ID:

```bash
gpg --list-secret-keys --keyid-format LONG
```

Example output includes something like:
- `sec rsa4096/ABCD1234EFGH5678 ...`

Set it for the commands below:

```bash
KEYID="ABCD1234EFGH5678"
```

## 2) Export key material (source machine)

```bash
gpg --armor --export "$KEYID" > pubkey.asc
gpg --armor --export-secret-keys "$KEYID" > privatekey.asc
gpg --export-ownertrust > ownertrust.txt
```

## 3) Transfer files to destination machine

Transfer these files securely:
- `pubkey.asc`
- `privatekey.asc`
- `ownertrust.txt`

Use USB you control or `scp` over SSH.
Do not send `privatekey.asc` over chat/email.

## 4) Import on destination machine

```bash
gpg --import pubkey.asc
gpg --import privatekey.asc
gpg --import-ownertrust ownertrust.txt
```

## 5) Verify key is present (destination machine)

```bash
gpg --list-keys
gpg --list-secret-keys --keyid-format LONG
```

## 6) Quick encryption/decryption test

```bash
echo "ok" | gpg -ear "$KEYID" > test.gpg
gpg -d test.gpg
```

Expected decrypt output: `ok`

## 7) Use with this repo's `crypt` script

Encrypt a directory:

```bash
./crypt "$KEYID" -e secrets
```

Decrypt from `encrypted_filesystem.tar.gz.gpg` into current directory:

```bash
./crypt "$KEYID" -d
```

## 8) Optional cleanup after transfer

After successful import and test, remove exported key files from temporary locations:

```bash
rm -f privatekey.asc ownertrust.txt test.gpg
```

## 9) Commit with automatic encrypt/decrypt

This repo includes a commit helper that enforces this flow:
1. Encrypt `secrets/`
2. Stage `encrypted_filesystem.tar.gz.gpg`
3. Run `git commit ...`
4. Decrypt back to restore `secrets/`

The public KEY and paths are configured in:
- `repo-secrets-config.sh`

Use it like this:

```bash
./secure-commit -m "your commit message"
```
