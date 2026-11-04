# Gerador de imagens local, sem gastar token

Gere imagens a partir de um texto (prompt) **no seu próprio computador**: sem internet, sem assinatura e sem gastar um token de IA.

Criei este projeto para desenhar o **Root**, o mascote da **Elite TI**, uma plataforma de estudo para concursos públicos de TI. Ele substitui o Gemini e o ChatGPT na hora de gerar imagens: você digita o prompt no terminal e a imagem aparece numa pasta.

## Como funciona

```
seu prompt  ──►  gerar.ps1  ──►  sd-cli.exe (stable-diffusion.cpp)  ──►  imagens/img-....png
                                     │
                                     ├─ modelo SDXL (sabe desenhar)
                                     └─ VAE fp16 fix (acabamento da imagem)
```

| Peça | O que é |
|---|---|
| **[stable-diffusion.cpp](https://github.com/leejet/stable-diffusion.cpp)** | Programa open source em C++ que roda o Stable Diffusion sem Python. Uso a versão **Vulkan**, que funciona com placas NVIDIA, AMD e Intel |
| **[SDXL base 1.0](https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0)** | O modelo que gera as imagens (6,9 GB). A licença (CreativeML Open RAIL++-M) permite uso comercial |
| **[SDXL VAE fp16 fix](https://huggingface.co/madebyollin/sdxl-vae-fp16-fix)** | Corrige erros de cor quando o SDXL roda em meia precisão, o que economiza memória de vídeo |
| **`gerar.ps1`** | Script em PowerShell que esconde o comando enorme atrás de opções simples |

Para caber numa placa de vídeo de **4 GB**, o script usa três truques:
- `--type q8_0`: comprime o modelo
- `--offload-to-cpu`: usa a memória RAM quando a placa enche
- `--vae-tiling`: monta a imagem em pedaços

## Resultado neste PC

- **Máquina:** RTX 2050 (4 GB) e 32 GB de RAM
- **Tempo:** cerca de **80 segundos** por imagem de 768×768
- **Custo:** zero

## Instalação (Windows)

1. Clone o repositório:
   ```powershell
   git clone https://github.com/Phb29/gerador-imagens-local.git
   cd gerador-imagens-local
   ```
2. **Programa:** em [releases do stable-diffusion.cpp](https://github.com/leejet/stable-diffusion.cpp/releases), baixe o `.zip` de Windows com **vulkan** no nome. Descompacte na pasta `sd-cpp-vulkan\`.
3. **Modelo:** baixe `sd_xl_base_1.0.safetensors` e coloque em `modelos\`.
4. **VAE:** baixe `sdxl_vae.safetensors`, renomeie para `sdxl_vae_fp16_fix.safetensors` e coloque em `modelos\`.

O programa e os modelos ficam fora do Git, pelo `.gitignore`, porque passam de 7 GB.

A estrutura final fica assim:

```
gerador-imagens-local/
├── gerar.ps1
├── sd-cpp-vulkan/sd-cli.exe   (+ DLLs)
└── modelos/
    ├── sd_xl_base_1.0.safetensors
    └── sdxl_vae_fp16_fix.safetensors
```

## Como usar

```powershell
# 1 imagem
.\gerar.ps1 "cute owl student mascot, flat 2D, cartoon"

# 4 imagens de uma vez, menores (mais rápido)
.\gerar.ps1 "seu prompt" -Quantidade 4 -Largura 768 -Altura 768

# Refazer exatamente a mesma imagem
.\gerar.ps1 "seu prompt" -Seed 123
```

As imagens saem em `imagens\`, com data e hora no nome.

| Opção | Padrão | Para quê |
|---|---|---|
| `-Quantidade` | 1 | Quantas imagens gerar |
| `-Largura` / `-Altura` | 1024 | Tamanho. 768 é mais rápido |
| `-Passos` | 25 | Mais passos = mais detalhe, porém mais lento |
| `-Seed` | -1 (aleatória) | Mesma seed + mesmo prompt = mesma imagem |
| `-Negativo` | realistic, photo, blurry... | O que você **não** quer na imagem |

## Exemplo: o prompt do Root

```powershell
.\gerar.ps1 "cute brazilian mutt dog mascot, caramel tan short fur, pointy ears, friendly calm smile, wearing a blue hoodie, holding a laptop, smart teacher vibe, flat 2D vector illustration, cartoon, thick outline, full body, front view, plain white background" -Quantidade 4 -Largura 768 -Altura 768
```

## Dicas

- **Escreva o prompt em inglês**: o SDXL entende melhor.
- **Feche OBS e jogos antes de gerar**: eles disputam a memória da placa de vídeo.
- **Anote a seed** que aparece nas mensagens quando gostar de uma imagem, para conseguir refazê-la.
- **Use a versão Vulkan**: a versão CUDA deu "device kernel image is invalid" com um driver NVIDIA mais antigo, e a Vulkan funcionou sem trocar o driver.
