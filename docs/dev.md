# Development

## Requirements

- Ruby v3.2+
- Node.js v22+
- Python
- Docker (Docker Compose)
- [actionlint](https://github.com/rhysd/actionlint)

## Main Directories

```
.
├── docs      # MKDocs based docs
├── frontend  # Vue.js based frontend
├── lib       # Mihari gem
└── spec      # Rspec tests
```

## Project Setup

```bash
# Install Ruby dependencies
bundle install
# Install Lefthook hook
lefthook install
# Install Python dependencies for documentation (optional)
pip install -r requirements.txt
# Install Node.js dependencies (optional)
cd frontend
npm install
```

## Tips

### How to Run Tests

```bash
bundle exec rake
```

```bash
cd frontend
npm run test:unit
```

### How o Build the Frontend

The repository does not contain the built frontend assets. So you have to build the frontend to dev/test the web app.

```bash
cd frontend
npm run build
```

Alternatively, you can do it by:

```bash
./build_frontend.sh
```

### How to Build the Docs

```bash
mkdocs build
# or
mkdocs serve
```
