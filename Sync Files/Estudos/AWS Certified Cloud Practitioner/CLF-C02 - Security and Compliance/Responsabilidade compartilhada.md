
Entendo que por padrão a AWS tem suas responsabilidades assim como o cliente também tem, por padrão, é assim que funciona:
![[Pasted image 20260511115425.png]]

Mas tudo pode variar de acordo com o Serviço... existem serviços IaaS, PaaS e Saas, que são modelos diferentes e possuem estruturas de responsabilidades variadas por fazerem parte de um modelo de negócio variado.

Esses modelos determinam cada um, o que é de nossa responsabilidade ou não, segue o gráfico:
![[Pasted image 20260511115611.png]]


On-site: quando temos uma infraestrutura totalmente on-premisses (dentro de "casa"), toda a responsabilidade é nossa, por exemplo: ar-condicionado, fiações, espaço, organização, servidores, discos e etc... basicamente é tudo nosso, então nós gerenciamos tudo, existem vantagens e desvantagens.

IaaS: não somos responsáveis pela infraestrutura, então podemos nos preocupar somente com o que roda ali, como as aplicações, os dados, o sistema operacional, são as camadas que não são físicas, resumindo bem: somos responsáveis apenas pelo software

PaaS: nesse modelo nós não somos responsáveis pelo software... já existem pessoas gerenciando a infraestrutura para nós e também a forma que as coisas rodam, tipo: qual sistema operacional é, atualização, dados, e etc... nesse caso, nós nos preocupamos apenas em gerenciar a plataforma.
Exemplos: DynamoDB, Lambda, 