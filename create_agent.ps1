param(
    [Parameter(Mandatory = $true)]
    [string]$AgentId,

    [Parameter(Mandatory = $true)]
    [string]$DisplayName,

    [Parameter(Mandatory = $true)]
    [string]$IdentityPrompt
)

# OpenClaw automated agent creation script for Windows PowerShell.
# AgentId: agent ID, for example: product_manager
# DisplayName: friendly display name, for example: Product Manager
# IdentityPrompt: detailed persona/system prompt

$ErrorActionPreference = "Stop"

$WorkspaceDir = Join-Path $HOME ".openclaw\workspace-$AgentId"
$ConfigFile = Join-Path $HOME ".openclaw\openclaw.json"

Write-Host "🚀 [1/3] Creating Agent ID: $AgentId..."

# Step 1: Create the base agent entry.
& openclaw agents add $AgentId --workspace $WorkspaceDir
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Agent creation failed. The ID [$AgentId] may already exist."
    exit 1
}
Write-Host "✅ Base agent entry created."

# Step 2: Update the display name in openclaw.json.
Write-Host "📝 [2/3] Updating $ConfigFile with display name: $DisplayName..."

if (-not (Test-Path -LiteralPath $ConfigFile)) {
    Write-Host "❌ Error: Config file not found: $ConfigFile"
    exit 1
}

$Config = Get-Content -LiteralPath $ConfigFile -Raw -Encoding UTF8 | ConvertFrom-Json
$Found = $false

if ($null -ne $Config.agents -and $null -ne $Config.agents.list) {
    foreach ($Agent in $Config.agents.list) {
        if ($Agent.id -eq $AgentId) {
            $Agent.name = $DisplayName
            $Found = $true
            break
        }
    }
}

if ($Found) {
    $Config | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath $ConfigFile -Encoding UTF8
    Write-Host "✅ Updated the name for ID [$AgentId] to [$DisplayName]"
} else {
    Write-Host "⚠️ No matching agent entry found in openclaw.json"
}

# Step 3: Inject the persona/system prompt.
Write-Host "🧠 [3/3] Injecting persona for ID [$AgentId]..."
$FullMessage = "Remember your identity and operating instructions:" + [Environment]::NewLine + $IdentityPrompt

& openclaw agent --agent $AgentId --message $FullMessage
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Persona injection failed. Please check the agent status manually."
} else {
    Write-Host "✅ Persona injection completed."
}

Write-Host "🎉 SUCCESS! Agent [$DisplayName] is ready."
exit 0
