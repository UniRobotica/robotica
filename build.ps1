# Limpa builds anteriores
jb clean .

# Gera o site
jb build .

# Remove docs antigo (evita arquivos quebrados)
if (Test-Path docs) {
    Remove-Item docs -Recurse -Force
}

# Copia tudo corretamente (incluindo CSS/JS/assets)
robocopy _build\html docs /MIR

# Abre no navegador para teste local
Start-Process docs\index.html