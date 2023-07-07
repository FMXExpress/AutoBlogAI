# AutoBlogAI
Automatically build outlines and blog posts using GPT-3.5-turbo, GPT-4, and Vicuna-13b LLMs using a cross-platform desktop client.

Language Models supported:
* vicuna-13b
* gpt-4 - OpenAI
* gpt-4-0314 - OpenAI
* gpt-4-32k - OpenAI
* gpt-4-32k-0314 - OpenAI
* gpt-3.5-turbo - OpenAI
* gpt-3.5-turbo-0301 - OpenAI

Built with [Delphi](https://www.embarcadero.com/products/delphi/) using the FireMonkey framework this client works on Windows, macOS, and Linux (and maybe Android+iOS) with a single codebase and single UI. At the moment it is specifically set up for Windows.

It features a REST integration with Replicate.com and OpenAI for providing generative text functionality within the client. You need to sign up for an API keys to access that functionality. Replicate models can be run in the cloud or locally via docker.

```
docker run -d -p 5000:5000 --gpus=all r8.im/replicate/vicuna-13b@sha256:6282abe6a492de4145d7bb601023762212f9ddbbe78278bd6771c8b3b2f2a13b
curl http://localhost:5000/predictions -X POST -H "Content-Type: application/json" \
  -d '{"input": {
    "prompt": "...",
    "max_length": "...",
    "temperature": "...",
    "top_p": "...",
    "repetition_penalty": "...",
    "seed": "...",
    "debug": "..."
  }}'
```

# AutoBlogAI Desktop client Screeshot on Windows
![AutoBlogAI Desktop client on Windows](/screenshot.png)

Other Delphi AI clients:

[AI Code Translator](https://github.com/FMXExpress/AI-Code-Translator)

[AI Playground](https://github.com/FMXExpress/AI-Playground-DesktopClient)

[Song Writer AI](https://github.com/FMXExpress/Song-Writer-AI)

[Stable Diffusion Text To Image Prompts](https://github.com/FMXExpress/Stable-Diffusion-Text-To-Image-Prompts)

[Generative AI Prompts](https://github.com/FMXExpress/Generative-AI-Prompts)

[Dreambooth Desktop Client](https://github.com/FMXExpress/DreamBooth-Desktop-Client)

[Text To Vector Desktop Client](https://github.com/FMXExpress/Text-To-Vector-Desktop-Client)
