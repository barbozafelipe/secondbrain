eu não preciso fazer com que o dev escolha qual conta ele deve acessar, ela criou errado
eu pedi pra criar os grupos dev prod e qa (ela criou qa no ad, mas não mapeou no sailpoint) developer
ela esqueceu de criar qa
não precisa criar três grupos, ela tem que criar br_awszpy_ia_developer, somente um grupo
apenas o: BR_AWSZPY_IA_DEVELOPER
quando u user pedir acesso a o grupo e for concedido, automaticamente já vai ter acesso aos três ambientes, mas eles não estarão com a mesma permissão de acesso, permition set para dev, qa e prod

vai aparecer o grupo em groups, (já está), vai aparecer o IA developer (BR_AWSZPY_IA_DEVELOPER), quando selecionar, em aws accounts, vai estar associado as três contas (dev, prod, qa), em cada conta associada ao grupo, terá um permition set.

o time de ia precisarão de acessos diferenciados, prod será apenas leitura, dev a gente vai dar permissão para fazer alterações etc, mas não sabemos quais recursos vão usar, podemos aplicar um permition set default do que já temos pra dev e ir ajustando conforme necessidade (mesma coisa com o permition set de qa, usaremos o default para qa e ajustamos conforme necessidade)

temos que entender quais tipos de serviço eles vão usar.

sobre os permition sets default: vou usar o mesmo padrão "BR_PS_CPP_DEV", vou usar esse cara para dev, "BR_PS_CPP_QA" para qa

criar o permition st nos dois portais, tanto da corpay quanto zapay, pra poder ficar igual, vai que iremos migrar tudo da payer da zapay para dentro da nossa payer, já terei tudo la

ajustar primeiro no sailpoint, quando aparecer na aws, vou vendo permition set e plugando com as contas, só ir em identity center, groups, vai aparecer o grupo BR_AWSZPY_IA_DEVELOPER, vou pegar ele, colocar as contas em AWS Accounts

[[ZPY - PTSK0010372]]