**Wellington:**  
Nosso amigo do time de GCP, Google, tá? Temos o Messias também trabalhando com a gente, ajudando bastante. Mas eu trouxe todo mundo porque todo mundo está metendo a mão lá: o Thiago, o Léo, o Matheus. Estamos fazendo os ajustes dos workloads no cluster, enfim.  
A ideia é que, depois dessa nossa conversa, o João e o Messias já venham trazendo muita coisa. Eles estão mexendo bastante nas questões de usuários, service accounts, e estamos cada vez mais descendo um nível para poder fazer a gestão e o entendimento.  
Eles já começaram, e a gente também já começou, a se questionar em relação a como está a gestão, principalmente de infraestrutura: quem tem acesso, como está sendo executado, qual usuário de serviço está executando. Então provavelmente essa galera, principalmente o João, vai começar a te procurar para alinharmos essas questões.  
O Thiago comentou que conversou com o João também e elogiou bastante ele.

**Pessoa não identificada:**  
É ótimo ter uma força extra de GCP para a gente.

**Pessoa não identificada:**  
Vou entrar aqui com outra conta, porque tive que entrar pelo celular. Meu fone do PC descarregou.

**Pessoa não identificada:**  
Você quer que eu te mande o link?

**Pessoa não identificada:**  
Não, só acho interessante a gente gravar essa reunião.

**Wellington:**  
Cara, pode ser ótimo. A gente coloca lá na pasta e ajuda.

**Pessoa não identificada:**  
Vou iniciar aqui então.

**Pessoa não identificada:**  
Beleza. Aqui acho que vai dar mais um overview. Para entrarmos em tópicos mais profundos, acho melhor fazer outras reuniões específicas.  
Eu não tenho uma visão 100% geral de IaC para trazer tanto detalhe para vocês, mas quis trazer esse tema porque notei, nesses dias em que estava tentando atualizar algumas coisas, que apareciam alguns blocos extras de CIDR no cluster.  
Sei que provavelmente vocês estavam alterando alguma coisa, tentando adicionar algum IP para fazer teste, alguma coisa assim. Aí fica nesses conflitos: às vezes precisa adicionar, às vezes vai acabar tirando. Então acho legal alinhar.  
O IaC acaba sendo o ponto de junção tanto de Devs quanto de Cloud. Acho que já tivemos uma reunião parecida antes, mas vou explicar de forma geral como está do lado da Gringo.  
O pessoal fez de um jeito um pouco bagunçado. É um repositório só para os dois ambientes principais, produção e staging. A maior diferença vem basicamente dessa pasta aqui, em resources. Deixa eu carregar.

**Pessoa não identificada:**  
Hoje temos esses dois aqui que não são mais usados, e temos produção e staging, que são os que o pessoal atualiza.

**Wellington:**  
Só uma pergunta: quando você fala que o pessoal atualiza, como está essa questão da parte de infraestrutura de Cloud? Quem tem permissão para ficar subindo as coisas?

**Pessoa não identificada:**  
O fluxo que a gente seguia antes, do lado da Gringo, era o seguinte: geralmente os devs precisam criar um tópico, uma subscription, ou algum outro recurso específico, como um banco de dados ou um serviço de banco que eles estão subindo.  
A gente permite que os devs baixem o repositório no PC deles, façam a atualização ou a criação do módulo seguindo o padrão que já está definido. Para a maioria das coisas já temos módulos prontos: Cloud SQL, Cloud Storage, Pub/Sub, Cloud Scheduler, essas coisas.  
Por exemplo, se o dev quer uma subscription com dead letter, a gente explica como usar. Ele só precisa adicionar isso no arquivo com os nomes e valores necessários. Depois a nossa parte é rodar o plan. Daqui a pouco mostro um exemplo. A gente roda o plan, valida, vê que está tudo tranquilo, aprova e sobe.  
Agora acho que o ideal seria passar por vocês primeiro, principalmente porque vocês têm controle de custo e tudo mais.

**Wellington:**  
E quem aprova isso?

**Pessoa não identificada:**  
Hoje sou eu que aprovo.

**Wellington:**  
Só você?

**Pessoa não identificada:**  
Sim.

**Wellington:**  
Isso já é uma coisa que eu queria mexer. Por exemplo, você falou que subiram rede, subnet e tudo mais. Muita coisa tem subido lá e a gente está fazendo um trabalho de organização. O João está vendo a questão de contas de usuário, service accounts etc.  
A gente está meio no escuro em relação ao que sobe e ao que não sobe. Não sei se depois a gente coloca você para nos avisar, ou cria um grupo aprovador com o pessoal de Cloud, para começarmos a ter rastreabilidade do que está subindo.  
Nesse primeiro momento, acho que não vale a pena engessar demais, mas acho que precisamos começar a aprovar esse tipo de coisa.

**Pessoa não identificada:**  
Acho que podemos criar um canal para os próprios devs pedirem solicitações relacionadas à infraestrutura. Talvez o pessoal da Gringo tenha esse costume. A gente deixa lá para qualquer coisa que envolva infra, porque aí fica todo mundo de olho.

**Wellington:**  
Exatamente. A gente pega para criar e aprovar esses recursos. Em produção, daqui a pouco isso vai ter que ser submetido via alguma Change, com certeza. Hoje eles sobem lá e nem a gente sabe.  
Tanto que o Leonardo recentemente deve ter falado contigo sobre criação de banco de dados ou algo assim.

**Pessoa não identificada:**  
Ele já tinha pedido para mim. Eu falei: “Tem que falar com o pessoal de Cloud para ver isso aí”.

**Wellington:**  
Isso, exatamente. Eu fiquei sabendo e a gente até passou para o time de banco criar. Mas precisamos da sua ajuda para fechar esses caminhos. Senão vamos ficar enxugando gelo em relação às service accounts que estão sendo feitas, porque não estamos conseguindo rastrear esses acessos através das pipelines.

**Pessoa não identificada:**  
Beleza. Só para dar um overview geral das pipelines: as pipelines que estamos usando agora são basicamente via GitHub Actions. Acho que as que permaneceram via Cloud Build são as partes de dados, e isso não está muito na nossa jurisdição.  
Se quiserem ter mais contato com esse pessoal, acho que talvez seja com o Rodolfo ou Sávio.

**Wellington:**  
Tenho conversado com ele, sim. O que combinei com o time é que, por enquanto, não estamos olhando muito para projetos do lado da Gringo relacionados a dados. Como você falou, eles estão em um mundo à parte. Para a gente, por enquanto, também estão em um mundo à parte, inclusive relacionado a orçamento.  
Eles podem rodar lá, mas não deveriam criar usuário ou projetos sem passar por nós. Agora, em relação às estruturas deles, como estão fazendo, por enquanto está sendo tratado em um orçamento apartado, dentro da estrutura deles.

**Pessoa não identificada:**  
Beleza. Só para trazer uma visão geral do que você falou de service accounts: geralmente automatizamos a criação delas pelos serviços. Cada serviço cria sua própria service account.  
No início do ano, aconteceu um incidente e, para a maioria deles, todos os valores caíram. Não sei mais como está hoje. Antigamente, como o pessoal ficava na Gringo, criavam e-mail para eles e a pessoa precisava adicionar alguns grupos padrão.  
Depois posso passar para vocês os grupos que o pessoal usa por padrão. Tem um grupo de acesso mais geral dentro de staging, para o pessoal poder testar e fazer validações, e um acesso mais restrito em produção, focado em visibilidade, para acompanhar status de serviços, banco de dados e coisas do tipo.

**Pessoa não identificada:**  
A gente foca mais na criação de recurso mesmo. Essa parte de rede depois podemos sentar e olhar. O que geralmente faço quando vejo conflito é: vejo que existe algo em produção e tento replicar em staging, para não quebrar nada e evitar estresse.  
Mas o padrão para os devs no dia a dia é esse: eles só podem criar recursos dentro do que já existe aqui. A maioria das coisas que eles criam é relacionada a Secret Manager, que é como eles controlam as variáveis dentro dos pods.

**Pessoa não identificada:**  
Um ponto que acho legal trazer é que o IaC, acho que já tínhamos conversado com o Thiago Barros um tempo atrás, precisa mudar de formato. Está muito bagunçado e muito dependente. Se dava problema em um recurso do GCP, ou antes, quando tinha conexão tanto com GitHub quanto com New Relic, acabava travando tudo. A gente ficava com isso inutilizado por aquele tempo.  
A ideia era tentar separar mais os módulos. Acho que nessa parte é legal vocês estarem juntos, porque vocês conseguem acompanhar melhor e controlar.

**Pessoa não identificada:**  
Os primeiros passos que podemos fazer agora são exatamente criar algum canal para o pessoal da Gringo mandar solicitações, até formalizarmos isso dentro do sistema de chamados, com fluxo de aprovação. Também podemos ajustar para que qualquer execução de Actions relacionada à infra passe por aprovação.

**Wellington:**  
Isso. A ideia aqui é bloquear o merge para qualquer pessoa sem permissão. Então a permissão ficaria com vocês.

**Pessoa não identificada:**  
Exato. O que fazemos hoje é o seguinte: quando eu abro um PR, é só um arquivo simples. A gente reaproveitou o que já estava da Gringo. Esse cara aqui roda um plan. Quando abrimos o PR, ele roda os testes do Terraform.  
Nesse caso, como o PR era para staging, ele devolveu esse plan para staging. A gente vem aqui e valida quais são os recursos daquela change. Aqui, por exemplo, foi a criação de um banco de dados, uma instância que já existia. Ele tentou criar 14 recursos, um para mudar uma configuração padrão do GCP.  
A gente olha tudo: o recurso novo, o que foi criado no PR, e aprova. A ideia é que isso também passe por vocês. Vocês dando aprovação, sobe.

**Wellington:**  
Perfeito. Por exemplo, o Messias está fazendo um trabalho bem pesado por exigências de segurança. Só de secrets, em produção, tem mais de 1.800. É muita coisa. Não tem governança nenhuma.  
Ele está fazendo scripts para ver o que está sendo utilizado. Tem chave que foi criada há muito tempo e tem seis versões ativas.  
Acho que secret talvez nem deveria estar no IaC. Estou levantando alguns pontos para o time e para você ajudarem a pensar. Não é para concordar com tudo, é para discutirmos.  
É algo sensível. Tem valores de banco ali. Teve um incidente na Gringo, se não me engano, relacionado a secret de banco. Então talvez a gente precise repensar essa questão de secret, acesso etc. A parte de acesso deve melhorar quando implementarmos Okta, mas precisamos avaliar.

**Pessoa não identificada:**  
Do lado da Gringo é assim: acho que os devs conseguem criar secret em produção, pelo menos eles faziam isso. Mas eles não conseguem alterar o valor da secret. O valor fica restrito a alguns grupos específicos.  
Eles não conseguem ver o valor em produção, só conseguem ver que a secret existe. O padrão é que as pessoas que conseguem ver e alterar geralmente são tech leads, porque às vezes estão em contato com cliente ou parceiro que vai fornecer o valor que precisa ser salvo na secret. Eles usam muito para Pix e coisas do tipo.  
Em staging, o acesso é mais liberado. Só que uma crítica que eu já fiz é que tem muita secret em staging que é igual à de produção.

**Wellington:**  
Se você consegue ver que ela é igual à de produção, é uma coisa. Se você consegue ver o valor de produção, aí muda.

**Pessoa não identificada:**  
Exato. Mas esse ponto eu sempre falei. É bom vocês mexerem nisso, porque é o espelho do que vocês mexem lá. Então também é uma responsabilidade de vocês.

**Wellington:**  
Perfeito. Eu te interrompi. Se quiser, dá uma passada geral para as pessoas mais novas entenderem como está.

**Pessoa não identificada:**  
Beleza. Como falei, está um pouco bagunçado. Não sei se vocês já conhecem a Yasu, do time de DevOps, que entrou mês passado. Ela está entrando mais nessa pegada para ajudar com Terraform. A ideia é fazer essa reformulação.  
Hoje temos resources por ambiente. Por exemplo, dentro de produção, o pessoal organiza muito arquivo dentro de arquivo. Tudo que envolve aquele serviço fica ali. Se pegarmos um exemplo em produção, tem coisas de bucket, Pub/Sub e banco no mesmo arquivo.  
Quando roda o Terraform plan, ele olha produção inteira. Ele olha tudo junto.

**Wellington:**  
Então está emaranhado. Por isso demora tanto.

**Pessoa não identificada:**  
Exatamente. E às vezes você está mexendo em um banco, mas tem uma tabela para deletar, ou alguma coisa órfã, ou alguém alterou algo na mão que não tem nada a ver com o que você vai mexer, e trava tudo.

**Wellington:**  
Exato.

**Pessoa não identificada:**  
Esse é o principal ponto que a gente quer alterar. A ideia é separar os repositórios. Ter um repositório focado só em IAM, outro em Pub/Sub, outro em provisioning, outro em alguma outra parte. Assim diminui a dependência e o tempo.  
Agora está até mais rápido, porque tiramos a integração com New Relic e GitHub. Antigamente era coisa de meia hora esperando o plan rodar.  
Hoje, dentro de um serviço, eles criam a parte de banco de dados, tópico, subscription, buckets relacionados. Existe uma organização por serviço. Mas isso ainda está tudo dentro do mesmo bloco de ambiente.

**Wellington:**  
Então você tem coisas separadas por serviço, mas ainda tudo dentro de produção ou staging.

**Pessoa não identificada:**  
Isso. O ideal seria mudar para algo mais modular. Por exemplo, tem um serviço chamado DIT CS. Dentro dele tem módulos para criar tópico, banco de dados etc. Mas, para staging, é tudo uma coisa só. Ele olha Cloud SQL, cluster, todos os bancos, tudo.  
É essa organização que queremos atacar. Mas, do lado dos devs, eles não veem tudo isso. Eles só adicionam o bloco no arquivo do serviço que estão mexendo.

**Wellington:**  
Entendi.

**Pessoa não identificada:**  
Então é isso. Está bagunçado, mas é mais ou menos assim.

**Wellington:**  
Vou propor que o João, principalmente, e o Messias comecem a interagir contigo para vermos essa questão de aprovação.  
Tem também uma service account de Terraform que gostaríamos de rotacionar a chave e entender quem tem acesso. Ela está bem antiga. Como ela está organizada hoje?

**Pessoa não identificada:**  
Ela é salva como uma secret no GitHub. O Terraform acessa essa secret. É uma coisa que até deu dor de cabeça recentemente na migração. Existe uma pipeline que é um arquivo horroroso e serve para todos os possíveis caminhos.  
Ela valida qual action foi aberta. Se foi push, faz tudo até o apply. Se foi pull request, faz tudo até o plan baseado na branch.  
No final, ela pega a secret do Terraform em produção, salva localmente no runner temporariamente, só para rodar os comandos do Terraform e conseguir bater no GCP.

**Wellington:**  
Essa service account tem acesso a quê? Acho que ela é quase admin, não?

**Pessoa não identificada:**  
Se não me engano, é quase admin, sim. Acho que tem uma service account para produção e uma para staging. Vou até dar uma olhada depois.

**Wellington:**  
Por serem projetos diferentes, deve ser diferente. Mas essa rotação é necessária. Acho que, como já migraram para GitHub, vale a pena alterar, ficar em posse de vocês/DevOps, alterar na secret do GitHub e garantir a questão de acesso. Pode ter gente com acesso a essa conta.

**Pessoa não identificada:**  
Essa secret provavelmente nem deveria estar acessível para todo mundo. Tem que ver o que ela consegue fazer.

**Wellington:**  
João, anota essa para fazermos a rotação dessa chave. É perigoso.

**Pessoa não identificada:**  
Sim, é perigoso.

**Wellington:**  
Também precisamos ver se todo mundo tem acesso a esse repositório, porque vamos usar bastante.  
Tenho outra dúvida: estamos numa fase final de ajuste. O Léo e todo mundo aqui estão participando. Vamos conseguir baixar bastante o custo das contas com algumas ações. Teremos mais outras coisas na segunda e terça-feira que vão nos dar uma margem de custo para subir os GKE Standard.  
Inicialmente vamos subir esses GKE Standard. O trabalho será alinhar e entender como vamos fazer. Queremos tentar tirar o Kong, ou pelo menos não depender dessa estrutura como está hoje, e usar uma estrutura mais parecida com a da Zapay, via ArgoCD.  
A ideia é migrar esses workloads que estão no Autopilot, começando por staging, para dentro de um cluster GKE Standard.

**Pessoa não identificada:**  
Perfeito.

**Wellington:**  
Vamos precisar da sua ajuda, principalmente na parte de esteira. Não sei como está a questão das aplicações deles, o pipeline para rodar deploy. Imagino que vá dar trabalho.

**Pessoa não identificada:**  
Como está tudo dentro do GitHub, vai ser mais simples. É mais mudar para onde aponta, dar acesso à service account que usamos e o resto segue.

**Wellington:**  
Com isso, vamos colocar num padrão que usamos aqui: Argo, Ingress, e trabalhar com Spot, estendendo isso para os clusters Standard. Acho que vai ficar bem legal e dar mais autonomia, porque hoje a gente briga muito com o Autopilot.

**Pessoa não identificada:**  
Sim.

**Wellington:**  
E ele é muito caro. Então entendemos que será interessante fazer essa migração.  
Outra coisa: para a minha visão, não entendo muito o sentido do Kong ali na frente. Se você tiver uma visão diferente, acho interessante explicar.

**Pessoa não identificada:**  
O pessoal usa o Kong mais como agregador. Tem algumas chamadas que vão para Cloud Functions. Quando perguntei isso, o pessoal falou que era muito para separar esse redirecionamento e ter mais controle sobre como a entrada funciona e para onde manda dentro da infraestrutura.  
No início, eles queriam usar mais Cloud Functions. Depois acharam mais simples e rápido usar o máximo possível em GKE.  
Se conseguirmos fazer com que para o pessoal não exista essa diferença, não tem problema tirar o Kong. Até porque ele traz dores de cabeça, como vimos ontem.

**Wellington:**  
O que penso é: o que vai bater dentro do cluster pode ir para Ingress. Para Cloud Functions, podemos usar API Gateway. Não sei qual é o API Gateway do GCP, mas com certeza existe. O João pode falar melhor.

**Pessoa não identificada:**  
Tem o API Gateway e tem o Apigee, que é mais robusto e mais caro.

**Wellington:**  
Perfeito. Se para o usuário a interface continuar igual, as mesmas rotas levando para os mesmos lugares, acho que ninguém vai ligar.

**Pessoa não identificada:**  
Sim. O pessoal nem sabe que o Kong existe na maioria das vezes.

**Wellington:**  
Essa parte de DNS provavelmente é só virar para o novo endereço depois que fizermos toda a configuração e validação.  
Só acho importante entender se nessa camada do Kong existe algo implementado de autenticação ou autorização, algum plugin, alguma coisa do tipo.

**Pessoa não identificada:**  
Pelo que investiguei até hoje, o pessoal não usa nada de autenticação. É mais para roteamento. Eles usam duas rotas na Gringo: uma externa, tipo `api-prd.gringo...`, e uma interna, tipo `api-prd-interno.gringo...`.  
A interna fica disponível só dentro da VPN ou da VPC, e o pessoal usa muito para teste, para não ter esse roteamento vindo de fora.  
Uma coisa que eles usam é uma automação com OpenAPI em alguns repositórios. Eles conseguem liberar uma rota via Kong, seja na rota externa ou interna.  
A vantagem da rota interna é quando tem um serviço dentro da mesma VPC, mas eles não querem fazer a conexão direta via cluster. A externa é quando querem que o aplicativo ou a interface web bata naquele serviço.  
Se conseguirmos replicar esse tipo de comportamento, dá para matar o Kong com mais certeza.

**Wellington:**  
Perfeito.

**Pessoa não identificada:**  
Para acessar o Kong, dentro da VPN você pega o IP de qualquer máquina do Kong e acessa `http://IP:8002`. Ele abre a interface administrativa. Não tem autenticação configurada lá.

**Wellington:**  
Show. Talvez a gente configure só para termos visibilidade e depois desliga isso.

**Pessoa não identificada:**  
Sim.

**Wellington:**  
Não vamos definir aqui que vamos eliminar o Kong. Quero eliminar as instâncias da forma como estão sendo usadas hoje. Se acharmos que precisa usar Kong, tentamos colocar dentro do nosso cluster, com versionamento e controle. Só acho que a forma como ele está concebido hoje é muito ruim.

**Pessoa não identificada:**  
Muita coisa na Gringo começou de qualquer jeito porque precisava fazer funcionar. Depois foram chegando mais demandas e prioridades, e ficou naquela lógica de “se está funcionando, não mexe”. Mas tem muita coisa que dá para ajustar.

**Wellington:**  
Thiago, depois veja com o Ian a questão da VPN também, para a gente olhar como está.

**Pessoa não identificada:**  
Para acessar, vocês têm um usuário padrão. Ele está no Secret Manager do projeto. Tem login e senha, e o QR Code do 2FA fica em um bucket também. Acho que já mostrei esse bucket para vocês.  
O endereço padrão é algo como `vpn.gringo.com.br/admin`.

**Wellington:**  
Depois a gente abre e faz.

**Wellington:**  
Voltando um pouco na questão do GKE Standard: já fizemos um planejamento. Para não conflitar com a rede do PSC e tudo mais, pedi um CIDR para o time de networking para esse projeto de staging. Ele já fez uma divisão de subnets para subir o GKE.  
Eu queria entender como podemos usar a infraestrutura que existe hoje no Terraform para subir isso. Não precisa ser agora, mas queria um planejamento para subirmos tudo via IaC.

**Pessoa não identificada:**  
Vou procurar aqui para te mostrar. Acho que tem algo aqui, mas talvez o Autopilot tenha sido subido na mão.

**Wellington:**  
A ideia é subir toda a estrutura de rede, subnets, parte do cluster GKE e DNS via Terraform.

**Pessoa não identificada:**  
A parte de VPC tem aqui. Tem algumas coisas de firewall também. Podemos fazer via Terraform. É até bom, porque já separamos.  
Hoje tem um problema com o que foi feito: usam o mesmo módulo para criar tanto o cluster de staging quanto o de produção, alterando só o nome por variável. Então, se você muda uma configuração, muda automaticamente nos dois. Só que às vezes você não quer isso, porque staging geralmente é menor que produção.

**Wellington:**  
Sim. No nosso caso, eu queria criar separado. Temos um documento de arquitetura com todos esses CIDRs e tudo que queremos criar. Posso te passar para você dar uma olhada e definirmos?

**Pessoa não identificada:**  
Pode sim, claro.  
Eu acho que, se formos seguir essa linha, vale a pena subir isso apartado desse Terraform atual. Chamaria a Yasu para ajudar a organizar. Se começarmos um repo novo com essas coisas novas, estruturamos tudo certinho. Porque ficar hidratando esse Terraform atual vai ficar cada vez pior.

**Wellington:**  
Exato. Vou te mandar esse documento de arquitetura com o que pretendemos subir. Ele já tem até comandos de `gcloud` para criação e tudo mais. Aí a gente volta a conversar, apresenta internamente para o time e, provavelmente no meio da semana que vem, já começamos a pensar em subir staging.  
Podemos fazer essa subida juntos, a quatro mãos, para deixar certinho, no repo certo. Quando tiver um processo, seguimos focando.

**Pessoa não identificada:**  
Perfeito. Vai ser super bom.

**Wellington:**  
Da minha parte, acho que é isso. O mais importante é fecharmos essa visibilidade para não atrapalhar o trabalho do pessoal e começarmos uma nova abordagem de aprovação, processo e procedimento para criação de novos recursos e acessos.

**Pessoa não identificada:**  
Exatamente. Talvez a gente tenha um canal para o pessoal criar solicitações direto lá, especialmente para o que precisa ser mais controlado. Mas acho perfeito. Do meu lado está tranquilo.

**Wellington:**  
Acho que da minha parte está fechada. Se tiverem alguma dúvida, alguma coisa…

**Pessoa não identificada:**  
O importante é todo mundo baixar/clonar esse repositório para ir dando uma olhada, ver como conectar e como funciona.

**Pessoa não identificada:**  
Eu acho que ainda não tenho conta do GitHub aqui.

**Pessoa não identificada:**  
Tem que pedir acesso no GitHub Infra. Talvez começar pelo Zaza. Precisamos criar um grupo GitHub Cloud para a gente.

**Wellington:**  
A gente precisa de uma permissão um pouco maior.

**Pessoa não identificada:**  
Exatamente. Eu pedi meu acesso quando entrei, para ir no lado do repositório de infra, e até agora não foi aprovado.

**Wellington:**  
Passa para mim. Está pendente com ele ou acima dele?

**Pessoa não identificada:**  
Acho que está com ele.

**Pessoa não identificada:**  
Eu ia contar uma besteira: a gente já pediu tanto GitHub e nunca deram, porque falavam que não tinha licença ou algo assim.

**Wellington:**  
Mas agora a coisa vai. Vamos tentando.

**Pessoa não identificada:**  
Quando o PH estava saindo, ele fez algumas passagens de conhecimento. Se não me engano, uma delas foi em cima desse repositório de Terraform. Talvez tenha uma call gravada com uma explicação um pouco mais a fundo.

**Wellington:**  
Você falou uma coisa e eu acabei de lembrar. Acho que tenho esses vídeos. Isso estava dentro do OneDrive do Daniel. Quando o Daniel saiu, disponibilizaram o OneDrive para a gente fazer a movimentação das coisas. Teve várias passagens de conhecimento, não só desse assunto.  
Vou procurar aqui. Se tiver, coloco dentro do grupo de Cloud de GCP e aviso vocês. Acho que vale a pena dar uma olhada. É muito conteúdo, mas conforme formos mexendo agora, vale pegar os vídeos e ver.

**Pessoa não identificada:**  
Beleza.

**Wellington:**  
Obrigado, pessoal. A gente vai se falando. Estamos avançando e evoluindo ali, e vamos ajustando ao longo do caminho.

**Pessoa não identificada:**  
Valeu.