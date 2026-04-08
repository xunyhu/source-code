
---

## setup.sh

```bash
#!/bin/bash

# setup.sh - Automatically clones external source repositories into framework folders
# Usage: ./setup.sh

set -e  # Exit on error

# Color codes for pretty output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# ============================================
# CONFIGURATION - UPDATE THESE URLs
# ============================================

# TODO: Replace these with your actual repository URLs
REACT_REPO="https://github.com/facebook/react.git"
VUE_REPO="https://github.com/your-username/vue-source.git"
TYPESCRIPT_REPO="https://github.com/your-username/typescript-source.git"

# Optional: Specify specific branches (leave empty to use default branch)
REACT_BRANCH=""
VUE_BRANCH=""
TYPESCRIPT_BRANCH=""

# ============================================
# DO NOT EDIT BELOW THIS LINE
# ============================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Setting up external source repositories${NC}"
echo -e "${GREEN}========================================${NC}\n"

# Function to clone or update a repository
clone_or_update() {
    local framework=$1
    local repo_url=$2
    local branch=$3
    local target_dir="$framework/source"
    
    echo -e "${YELLOW}Processing $framework...${NC}"
    
    # Check if repo URL is still default
    if [[ "$repo_url" == *"your-username"* ]]; then
        echo -e "${RED}  ✗ Please edit setup.sh and update $framework repository URL${NC}"
        return 1
    fi
    
    # Check if directory already exists
    if [ -d "$target_dir" ]; then
        if [ -d "$target_dir/.git" ]; then
            echo -e "  ✓ $target_dir already exists and contains a git repository"
            
            # Optional: Update existing repository
            read -p "  Do you want to pull latest changes? (y/n) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                echo -e "  Pulling latest changes..."
                (cd "$target_dir" && git pull)
                echo -e "  ${GREEN}✓ Updated $framework${NC}"
            fi
        else
            echo -e "  ${RED}✗ $target_dir exists but is not a git repository${NC}"
            echo -e "  ${YELLOW}  Please remove or backup it manually${NC}"
            return 1
        fi
    else
        # Clone the repository
        echo -e "  Cloning $repo_url into $target_dir..."
        
        # Create parent directory if needed
        mkdir -p "$framework"
        
        # Clone with or without branch specification
        if [ -n "$branch" ]; then
            git clone --branch "$branch" "$repo_url" "$target_dir"
        else
            git clone "$repo_url" "$target_dir"
        fi
        
        if [ $? -eq 0 ]; then
            echo -e "  ${GREEN}✓ Successfully cloned $framework source${NC}"
        else
            echo -e "  ${RED}✗ Failed to clone $framework source${NC}"
            return 1
        fi
    fi
    
    echo ""
    return 0
}

# Track success/failure
FAILED=0

# Process each framework
clone_or_update "react" "$REACT_REPO" "$REACT_BRANCH" || FAILED=1
clone_or_update "vue" "$VUE_REPO" "$VUE_BRANCH" || FAILED=1
clone_or_update "typescript" "$TYPESCRIPT_REPO" "$TYPESCRIPT_BRANCH" || FAILED=1

# Summary
echo -e "${GREEN}========================================${NC}"
if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ All source repositories are set up!${NC}"
    echo -e "${GREEN}========================================${NC}\n"
    
    echo -e "You can now:"
    echo -e "  • Update individual repos: cd react/source && git pull"
    echo -e "  • Work on your core/notes folders"
    echo -e "  • Check parent git status: git status (should show no source/ folders)\n"
    
    echo -e "${YELLOW}Note:${NC} The parent repository ignores all source/ folders."
    echo -e "      Never commit external source code to the parent repo.\n"
else
    echo -e "${RED}✗ Some repositories failed to set up${NC}"
    echo -e "${RED}========================================${NC}\n"
    echo -e "Please check the errors above and fix them."
    exit 1
fi