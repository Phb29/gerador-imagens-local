# Gerador de imagens local (stable-diffusion.cpp + SDXL)

Gera imagens a partir de um texto (prompt), **no seu próprio PC**, sem internet e sem gastar token.
Foi com ele que criamos a coruja de teste e o Root, o mascote da Elite TI.

## As 3 peças

| Peça | O que é | Onde fica |
|---|---|---|
| **stable-diffusion.cpp** (versão Vulkan) | O programa que gera a imagem (`sd-cli.exe`) | `sd-cpp-vulkan\` |
| **SDXL base 1.0** | O "cérebro" que sabe desenhar (modelo de 6,9 GB). A licença permite uso comercial | `modelos\sd_xl_base_1.0.safetensors` |
| **VAE fp16 fix** | Peça que transforma o resultado do modelo na imagem final, sem bugs de cor | `modelos\sdxl_vae_fp16_fix.safetensors` |
| **gerar.ps1** | O atalho que escrevemos para não precisar decorar o comando enorme | `gerar.ps1` |

## Como instalar do zero (em outro PC)

O repositório no GitHub guarda só o script e as instruções. O programa e os modelos são grandes demais para o Git (quase 7 GB), então você baixa de novo:

0. **Este repositório:** `git clone https://github.com/Phb29/gerador-imagens-local.git videos-mascote`
1. **Programa:** baixe em https://github.com/leejet/stable-diffusion.cpp/releases o `.zip` de Windows com **vulkan** no nome. Descompacte na pasta `sd-cpp-vulkan\`.
   - Use o Vulkan. A versão CUDA deu erro com o driver da NVIDIA deste PC.
2. **Modelo:** baixe `sd_xl_base_1.0.safetensors` em https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0 e coloque em `modelos\`.
3. **VAE:** baixe `sdxl_vae.safetensors` em https://huggingface.co/madebyollin/sdxl-vae-fp16-fix, renomeie para `sdxl_vae_fp16_fix.safetensors` e coloque em `modelos\`.
4. Copie o `gerar.ps1` para a pasta principal.

## Como usar

Abra o PowerShell **nesta pasta** e rode:

```powershell
cd C:\Users\paulojesus\Projetos\videos-mascote

# 1 imagem
.\gerar.ps1 "seu prompt em inglês aqui"

# 4 imagens de uma vez, menores (mais rápido)
.\gerar.ps1 "seu prompt" -Quantidade 4 -Largura 768 -Altura 768

# Refazer exatamente a mesma imagem (repita a seed que você gostou)
.\gerar.ps1 "seu prompt" -Seed 123
```

As imagens saem em `imagens\`, com data e hora no nome.

### Opções do gerar.ps1

| Opção | Padrão | Para quê |
|---|---|---|
| `-Quantidade` | 1 | Quantas imagens gerar |
| `-Largura` / `-Altura` | 1024 | Tamanho. 768 é mais rápido |
| `-Passos` | 25 | Mais passos = mais detalhe, porém mais lento |
| `-Seed` | -1 (aleatória) | Mesma seed + mesmo prompt = mesma imagem |
| `-Negativo` | realistic, photo, blurry... | O que você **não** quer na imagem |

## Prompt do Root (mascote)

```powershell
.\gerar.ps1 "cute brazilian mutt dog mascot, caramel tan short fur, pointy ears, friendly calm smile, wearing a blue hoodie, holding a laptop, smart teacher vibe, flat 2D vector illustration, cartoon, thick outline, full body, front view, plain white background" -Quantidade 4 -Largura 768 -Altura 768
```

## Dicas

- **Prompt em inglês** funciona melhor.
- Cada imagem de 768px leva por volta de **80 segundos** neste PC (RTX 2050 de 4 GB).
- Feche OBS e jogos antes de gerar: eles disputam a memória da placa de vídeo.
- Gostou de uma imagem? Anote a seed que aparece nas mensagens para conseguir refazê-la.
- A pasta `sd-cpp\` (versão CUDA) não funcionou neste PC e pode ser apagada.
