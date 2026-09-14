# Launch local FastAPI backend and Cloudflare Tunnel

$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$cloudflared = Join-Path $repoRoot "cloudflared.exe"
$pythonExe = Join-Path $repoRoot "backend\.venv\Scripts\python.exe"

if (-not (Test-Path $cloudflared)) {
    Write-Error "cloudflared.exe was not found in the project root."
    exit 1
}

if (-not (Test-Path $pythonExe)) {
    Write-Error "Backend virtual environment python was not found."
    exit 1
}

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  MPNMJEC Smart Attendance - Cloudflare Tunnel Launcher  " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. Start backend process
Write-Host "`n[1/2] Starting local FastAPI backend on port 8000..." -ForegroundColor Yellow
$backendProcess = Start-Process -FilePath $pythonExe -ArgumentList "-m", "uvicorn", "backend.main:app", "--host", "127.0.0.1", "--port", "8000" -PassThru -NoNewWindow

Start-Sleep -Seconds 3

# 2. Start Cloudflare Tunnel
Write-Host "`n[2/2] Launching Cloudflare Tunnel..." -ForegroundColor Green
Write-Host "Look for your public HTTPS URL below (e.g. https://...trycloudflare.com):`n" -ForegroundColor Green

try {
    & $cloudflared tunnel --protocol http2 --url http://127.0.0.1:8000
} finally {
    if ($backendProcess -and -not $backendProcess.HasExited) {
        Write-Host "Stopping backend server..." -ForegroundColor Gray
        Stop-Process -Id $backendProcess.Id -Force -ErrorAction SilentlyContinue
    }
}
