# Gera uma imagem a partir de um prompt, usando o stable-diffusion.cpp e o modelo SDXL.
# Uso:
#   .\gerar.ps1 "mascote coruja estudante, flat 2D, cartoon"
#   .\gerar.ps1 "mascote coruja estudante" -Seed 123
#   .\gerar.ps1 "mascote coruja estudante" -Quantidade 4
param(
    [Parameter(Mandatory = $true)][string]$Prompt,
    [int]$Seed = -1,            # -1 = aleatória. Repita a mesma seed para refazer a mesma imagem.
    [int]$Quantidade = 1,       # quantas imagens gerar de uma vez
    [int]$Passos = 25,          # mais passos = mais detalhe, porém mais lento
    [int]$Largura = 1024,
    [int]$Altura = 1024,
    [string]$Negativo = "realistic, photo, 3d render, blurry, low quality, text, watermark, signature, deformed, extra limbs"
)

$raiz = $PSScriptRoot
$saida = Join-Path $raiz "imagens"
New-Item -ItemType Directory -Force $saida | Out-Null

$data = Get-Date -Format "yyyyMMdd-HHmmss"
$arquivo = Join-Path $saida "img-$data-%d.png"

# Versão Vulkan: funciona com o driver NVIDIA atual (a versão CUDA exigiria driver mais novo).
& "$raiz\sd-cpp-vulkan\sd-cli.exe" `
    -m "$raiz\modelos\sd_xl_base_1.0.safetensors" `
    --vae "$raiz\modelos\sdxl_vae_fp16_fix.safetensors" `
    --type q8_0 `
    --offload-to-cpu `
    --vae-tiling `
    -p $Prompt `
    -n $Negativo `
    -W $Largura -H $Altura `
    --steps $Passos `
    --cfg-scale 7 `
    --sampling-method dpm++2m `
    -s $Seed `
    -b $Quantidade `
    -o $arquivo

Write-Host ""
if ($LASTEXITCODE -ne 0) {
    Write-Host "Deu erro na geração (código $LASTEXITCODE). Veja as mensagens acima."
    exit $LASTEXITCODE
}
Write-Host "Pronto! Imagens salvas em: $saida"
