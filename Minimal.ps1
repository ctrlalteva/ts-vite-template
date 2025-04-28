param(
	[Parameter(Mandatory=$false)][string]$TargetDir
)

if (-not [string]::IsNullOrEmpty($TargetDir))
{
    mkdir $TargetDir
    Set-Location $TargetDir
}

npm create vite@latest . --- --template vanilla-ts --overwrite

Get-ChildItem -Path .\public -File -Recurse | Remove-Item
Get-ChildItem -Path .\src -File -Recurse | Remove-Item

New-Item src/main.ts

Remove-Item index.html
$htmlContent = @"
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Minimal App</title>
  </head>
  <body>
    <div id="app"></div>
    <script type="module" src="/src/main.ts"></script>
  </body>
</html>
"@
$htmlContent | Out-File -FilePath "index.html"

npm install --save-dev eslint typescript-eslint @eslint/js @stylistic/eslint-plugin

$eslintContent = @"
import eslint from '@eslint/js';
import tseslint from 'typescript-eslint';
import stylistic from '@stylistic/eslint-plugin';

export default tseslint.config(
  eslint.configs.recommended,
  tseslint.configs.strictTypeChecked,
  stylistic.configs.recommended,
  {
    languageOptions: {
      parserOptions: {
        projectService: true,
        tsconfigRootDir: import.meta.dirname,
      },
    }
  },
  {
    ignores: [
      "**/*.js",
      "**/dist/"
    ]
  }
);
"@
$eslintContent | Out-File -FilePath "eslint.config.js"