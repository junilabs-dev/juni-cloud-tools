# Automation Examples

Here are some real-world ways to use the `juni-cloud-tools` repository.

## Scenario 1: New Project Setup

When you start a new project, you can quickly bootstrap it:
```bash
./bash/enable-apis.sh
./bash/create-service-account.sh
./bash/create-storage-bucket.sh
```

## Scenario 2: Throwaway Development VM

Need a VM just for a few hours?
```bash
./bash/create-vm.sh

# Do your work...

# Clean it all up later!
./bash/cleanup.sh
```
