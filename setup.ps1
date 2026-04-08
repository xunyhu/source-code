# setup.ps1 - Cross-platform PowerShell script for Windows/Mac/Linux
# Usage: ./setup.ps1 (Windows) or pwsh setup.ps1 (Mac/Linux)

# Configuration - UPDATE THESE URLs
$REACT_REPO = "https://github.com/facebook/react.git"
$VUE_REPO = "https://github.com/your-username/vue-source.git"
$TYPESCRIPT_REPO = "https://github.com/your-username/typescript-source.git"

# Optional: Specify branches
$REACT_BRANCH = ""
$VUE_BRANCH = ""
$TYPESCRIPT_BRANCH = ""

# Colors
$GREEN = "`e[32m"
$YELLOW = "`e[33m"
$RED = "`e[31m"
$NC = "`e[0m"

Write-Host "${GREEN}========================================${NC}"
Write-Host "${GREEN}Setting up external source repositories${NC}"
Write-Host "${GREEN}========================================${NC}`n"

function CloneOrUpdate {
    param(
        [string]$Framework,
        [string]$RepoUrl,
        [string]$Branch
    )
    
    $TargetDir = "$Framework/source"
    
    Write-Host "${YELLOW}Processing $Framework...${NC}"
    
    if (Test-Path $TargetDir) {
        if (Test-Path "$TargetDir/.git") {
            Write-Host "  ✓ $TargetDir already exists and contains a git repository"
            
            $response = Read-Host "  Do you want to pull latest changes? (y/n)"
            if ($response -eq 'y') {
                Write-Host "  Pulling latest changes..."
                Push-Location $TargetDir
                git pull
                Pop-Location
                Write-Host "  ${GREEN}✓ Updated $Framework${NC}"
            }
        } else {
            Write-Host "  ${RED}✗ $TargetDir exists but is not a git repository${NC}"
            return $false
        }
    } else {
        Write-Host "  Cloning $RepoUrl into $TargetDir..."
        New-Item -ItemType Directory -Force -Path $Framework | Out-Null
        
        if ($Branch) {
            git clone --branch $Branch $RepoUrl $TargetDir
        } else {
            git clone $RepoUrl $TargetDir
        }
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  ${GREEN}✓ Successfully cloned $Framework source${NC}"
        } else {
            Write-Host "  ${RED}✗ Failed to clone $Framework source${NC}"
            return $false
        }
    }
    
    Write-Host ""
    return $true
}

$failed = $false

if (-not (CloneOrUpdate "react" $REACT_REPO $REACT_BRANCH)) { $failed = $true }
if (-not (CloneOrUpdate "vue" $VUE_REPO $VUE_BRANCH)) { $failed = $true }
if (-not (CloneOrUpdate "typescript" $TYPESCRIPT_REPO $TYPESCRIPT_BRANCH)) { $failed = $true }

Write-Host "${GREEN}========================================${NC}"
if (-not $failed) {
    Write-Host "${GREEN}✓ All source repositories are set up!${NC}"
    Write-Host "${GREEN}========================================${NC}`n"
    
    Write-Host "You can now:"
    Write-Host "  • Update individual repos: cd react/source && git pull"
    Write-Host "  • Work on your core/notes folders"
    Write-Host "  • Check parent git status: git status (should show no source/ folders)`n"
    
    Write-Host "${YELLOW}Note:${NC} The parent repository ignores all source/ folders."
    Write-Host "      Never commit external source code to the parent repo.`n"
} else {
    Write-Host "${RED}✗ Some repositories failed to set up${NC}"
    Write-Host "${RED}========================================${NC}`n"
    exit 1
}