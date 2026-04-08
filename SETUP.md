# Project Setup Guide

## Directory Structure

This repository has the following structure:

```text
source-code/
├── react/
│ ├── core/
│ ├── notes/
│ └── source/ # 独立的git仓库
├── vue/
│ ├── core/
│ ├── notes/
│ └── source/ # 独立的git仓库
└── typescript/
├── core/
├── notes/
└── source/ # 独立的git仓库
```

Each `source/` subfolder is an **independent git repository** (e.g., downloaded from GitHub).  
The parent repository (`source-code/`) ignores all `source/` folders via `.gitignore` to avoid nesting git repositories.

## Initial Setup After Cloning

When you clone this parent repository, the `source/` folders will be **empty** (since they are ignored by git).  
You need to manually clone the external source code into each framework's `source/` folder.

### Prerequisites

- Git installed on your system
- Access to the external source repositories (GitHub URLs)

### Option 1: Manual Setup

Run the following commands from the `source-code/` directory:

```bash
# Clone source for React
git clone <REACT_SOURCE_URL> react/source

# Clone source for Vue
git clone <VUE_SOURCE_URL> vue/source

# Clone source for TypeScript
git clone <TYPESCRIPT_SOURCE_URL> typescript/source
```

## Running the Setup Script

### On Mac / Linux

```bash
chmod +x setup.sh
./setup.sh
```

### On Windows

Use Git Bash (comes with Git for Windows):

```bash
./setup.sh
```

Or use PowerShell:

```bash
.\setup.ps1
```

### Manual Setup (All Platforms)

If scripts don't work, run these commands manually:

```bash
git clone <react-url> react/source
git clone <vue-url> vue/source
git clone <typescript-url> typescript/source
```
