# ☁️ Google Cloud Automation Toolkit

![Bash](https://img.shields.io/badge/Bash-Scripting-green)
![Python](https://img.shields.io/badge/Python-3.x-blue)
![Google Cloud](https://img.shields.io/badge/Google-Cloud-blue)
![License](https://img.shields.io/badge/License-MIT-yellow)

🚀 Reusable Bash and Python automation scripts for Google Cloud. 

This repository, **juni-cloud-tools**, is a collection of utilities to help developers, DevOps engineers, and cloud enthusiasts automate routine infrastructure tasks on GCP.

## 📂 Repository Structure

```text
juni-cloud-tools/
├── bash/             # Core automation shell scripts
│   ├── utils.sh      # UI helper functions (banners, logging)
│   ├── enable-apis.sh
│   ├── create-vm.sh
│   └── ...
├── python/           # Python SDK examples & automation
│   ├── storage/
│   ├── vision/
│   └── bigquery/
├── tutorials/        # Scenario-based scripts for YouTube episodes
│   └── Episode-01-ML-APIs/
├── docs/             # Documentation and usage guides
├── .github/          # CI/CD Workflows (Shellcheck)
├── .gitignore
├── LICENSE
└── README.md
```

## 🛠️ Usage (Bash)

The scripts are located in the `bash/` directory and share a common, colorful UI loaded from `utils.sh`.

```bash
cd bash/
chmod +x install-sdk.sh
./install-sdk.sh
```

## 🐍 Usage (Python)

Ensure you have authenticated and installed `google-cloud-*` libraries before running the python scripts.

```bash
pip install google-cloud-storage google-cloud-vision google-cloud-bigquery
python python/storage/upload.py <bucket_name> <source_file> <destination_blob>
```

## 📖 Documentation
Check out the [docs/](./docs) directory for:
- [Bash Scripting Best Practices](./docs/bash.md)
- [gcloud Getting Started](./docs/gcloud.md)
- [Real-world Examples](./docs/examples.md)

## 🤝 Contributing
Feel free to open issues or submit pull requests. Let's build a strong automation portfolio!
