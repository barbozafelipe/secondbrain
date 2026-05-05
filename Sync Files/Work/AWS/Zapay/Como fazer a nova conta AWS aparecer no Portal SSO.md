

**Lucas Paulo Gonçalves Martins Mendes — 05:36**  
Aqui, na mão.

**Lucas Paulo Gonçalves Martins Mendes — 05:38**  
Da Cloud, todas aquelas contas aparecem para a gente porque estão associadas aqui. Está vendo?

Então, se tiver mais alguma conta que a gente precise ter acesso, é só vir aqui, selecionar a conta que eu quero, selecionar a permissão que eu quero para essa conta e atribuir.

**Felipe Barboza Gonçalves — 05:46**  
Uhum.

**Felipe Barboza Gonçalves — 05:53**  
Ok.

**Lucas Paulo Gonçalves Martins Mendes — 05:55**  
A partir desse momento, é só fazer login e logoff no portal que a conta já vai aparecer.

**Felipe Barboza Gonçalves — 06:00**  
Saquei. Então, de boa. Não é nada absurdo assim, né?

**Lucas Paulo Gonçalves Martins Mendes — 06:03**  
É tranquilo, não é nenhum bicho de sete cabeças. É mais manter o padrão de criação, principalmente na parte do nome do Permission Set e do nome dos grupos. O restante é mais parte técnica mesmo.

**Felipe Barboza Gonçalves — 06:17**  
Beleza, beleza. Deixa eu ver um negócio.

Eu tinha aberto aqui um chamado pedindo para eles criarem as contas, e coloquei `PRD`, não coloquei `PROD`. Estou vendo que aí está tudo como `PROD`. Acho que seria uma boa eu atualizar lá e pedir para ajustar.

**Lucas Paulo Gonçalves Martins Mendes — 06:38**  
Isso, mantém o padrão de `PROD`.

**Felipe Barboza Gonçalves — 06:41**  
Certo.

**Lucas Paulo Gonçalves Martins Mendes — 06:41**  
Se der tempo, beleza. Se não der, não tem problema. É mais alinhamento mesmo.

**Felipe Barboza Gonçalves — 06:53**  
Tá. O cara respondeu aqui:

“Bom dia, precisamos dos e-mails com o domínio da Zapay para vincular à criação das novas contas na AWS.”

**Lucas Paulo Gonçalves Martins Mendes — 07:01**  
Essa parte eu também estava em dúvida, porque não sei se a gente precisa criar um e-mail fictício e mandar para eles, ou se já existe algum e-mail, ou se precisa pedir para alguém criar esse e-mail antes.

Aí teria que ver com o Mateus ou com o Wellington como é feita essa parte.

**Felipe Barboza Gonçalves — 07:16**  
Vou ver com o Mateus e perguntar para ele. Beleza, fechou.

Aí, com o que o Mateus falar, eu sigo aqui. Também peço para eles colocarem `PROD` em vez de `PRD`.

**Lucas Paulo Gonçalves Martins Mendes — 07:29**  
Demorou. Se tiver alguma dúvida na hora de fazer as coisas, é só dar um toque.

**Felipe Barboza Gonçalves — 07:35**  
Fechou, mano. Obrigadão por explicar. É nóis, falou.

**Lucas Paulo Gonçalves Martins Mendes — 07:36**  
Fechou, é nóis. Falou.

---

Um ponto importante dessa transcrição é que ela confirma duas coisas:

```text
1. Para a conta aparecer no Portal AWS SSO, precisa associar a conta + grupo/permissão no IAM Identity Center.

2. O padrão correto do ambiente produtivo deve ser PROD, não PRD.
```