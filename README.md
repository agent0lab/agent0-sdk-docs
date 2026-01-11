## Agent0 SDK Docs

This folder (`agent0-sdk-docs/`) is the source for the Agent0 SDK documentation site, built with:

- Astro `5.15.1`
- Starlight `0.36.1`

### Install

From repo root:

```bash
cd agent0-sdk-docs
npm install
```

If you installed Node via `nvm` and `npm` is not on PATH in non-interactive shells, run commands like this:

```bash
cd agent0-sdk-docs
PATH="$HOME/.nvm/versions/node/v24.12.0/bin:$PATH" npm install
```

### Dev server

```bash
cd agent0-sdk-docs
npm run dev
```

### Build

Build output goes to `agent0-sdk-docs/dist/`.

```bash
cd agent0-sdk-docs
npm run build
```

### Publish to S3 (`sdk.ag0.xyz`)

Publishing uploads the compiled `dist/` output to the S3 bucket `arn:aws:s3:::sdk.ag0.xyz`.

Setup:

```bash
cd agent0-sdk-docs
cp s3-publish.env.example s3-publish.env
```

Edit `agent0-sdk-docs/s3-publish.env` and choose one auth option:

- Use an AWS CLI profile: set `AWS_PROFILE`
- Paste credentials: set `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY` (and optionally `AWS_SESSION_TOKEN`)
- Use a JWT (web identity): set `AWS_ROLE_ARN` and `AWS_WEB_IDENTITY_JWT`

Publish:

```bash
cd agent0-sdk-docs
npm run publish:s3
```

Note: the bucket has ACLs disabled, so the publish script does **not** set object ACLs; public access must be controlled by the bucket policy / static website config.

