<#
.SYNOPSIS
  生成 c-coding-style GitHub social preview 图 (1280x640 PNG)。
.DESCRIPTION
  使用 System.Drawing 绘制, 不依赖 AI 图像生成, 文字渲染精确。
  借鉴 xwos / anthropics 等仓库的 social preview 设计语言。
.NOTES
  长期脚本, 随 skill 一同发布。重新运行可重新生成图。
.EXAMPLE
  pwsh scripts/render-social-preview.ps1
#>

param(
    [string]$OutputPath = (Join-Path $PSScriptRoot "..\assets\social-preview.png"),
    [int]$Width = 1280,
    [int]$Height = 640
)

Add-Type -AssemblyName System.Drawing

$OutputPath = [System.IO.Path]::GetFullPath($OutputPath)
$OutputDir = Split-Path -Parent $OutputPath
if (-not (Test-Path $OutputDir)) { New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null }

$bmp = New-Object System.Drawing.Bitmap($Width, $Height)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic

$bgRect = New-Object System.Drawing.Rectangle(0, 0, $Width, $Height)
$bgBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    $bgRect,
    [System.Drawing.Color]::FromArgb(255, 13, 27, 42),
    [System.Drawing.Color]::FromArgb(255, 27, 58, 75),
    [System.Drawing.Drawing2D.LinearGradientMode]::Vertical
)
$g.FillRectangle($bgBrush, $bgRect)

$gridPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(60, 0, 217, 255), 1)
for ($x = 850; $x -lt $Width; $x += 30) {
    $g.DrawLine($gridPen, $x, 0, $x, $Height)
}
for ($y = 60; $y -lt $Height; $y += 30) {
    $g.DrawLine($gridPen, 850, $y, $Width, $y)
}

$titleFont = New-Object System.Drawing.Font("Consolas", 72, [System.Drawing.FontStyle]::Bold)
$titleBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
$g.DrawString("c-coding-style", $titleFont, $titleBrush, 70, 170)

$accentBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 0, 217, 255))
$accentPen = New-Object System.Drawing.Pen($accentBrush, 4)
$g.DrawLine($accentPen, 70, 260, 280, 260)

$subFont = New-Object System.Drawing.Font("Microsoft YaHei UI", 32)
$subBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 220, 230, 240))
$g.DrawString("C 编码风格 + Doxygen 注释规约", $subFont, $subBrush, 70, 300)

$subEnFont = New-Object System.Drawing.Font("Arial", 16, [System.Drawing.FontStyle]::Italic)
$subEnBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 180, 200, 215))
$g.DrawString("Coding standards for embedded / safety / automotive C teams", $subEnFont, $subEnBrush, 70, 350)

$tagFont = New-Object System.Drawing.Font("Microsoft YaHei UI", 18)
$tagBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 0, 217, 255))
$tagText = "MISRA C 2012     |     Embedded     |     Claude Code + Codex + Hermes + Cursor"
$g.DrawString($tagText, $tagFont, $tagBrush, 70, 410)

$iconFont = New-Object System.Drawing.Font("Consolas", 180, [System.Drawing.FontStyle]::Bold)
$iconBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(120, 0, 217, 255))
$g.DrawString("{ ;", $iconFont, $iconBrush, 920, 170)

$badgeFont = New-Object System.Drawing.Font("Arial", 13)
$badgeBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 150, 170, 190))
$badgeText = "Claude Code  -  Codex  -  Hermes  -  Cursor  -  Kilo Code  -  Windsurf  -  OpenCode  -  Augment  -  Antigravity  -  Aider"
$g.DrawString($badgeText, $badgeFont, $badgeBrush, 70, 540)

$footFont = New-Object System.Drawing.Font("Consolas", 14)
$footBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 120, 140, 160))
$g.DrawString("github.com/USER/c-coding-style", $footFont, $footBrush, 70, 580)
$g.DrawString("MIT License", $footFont, $footBrush, 70, 605)

$g.Dispose()
$bmp.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()

Write-Host "Social preview generated: $OutputPath"
Write-Host "  Size: $Width x $Height PNG"
