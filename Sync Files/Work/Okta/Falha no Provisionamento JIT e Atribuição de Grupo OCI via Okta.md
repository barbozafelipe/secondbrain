
O grupo da OCI precisa estar mapeado em Push Groups do Aplicativo (OCI) no Okta. Necessário dar um Refresh App Groups (se for um grupo novo) e fazer o link entre o grupo do AD (ex: BR_OCIGROUP_DIGITAL) e o grupo na OCI (ex: BR_OCIGROUP_DIGITAL), conforme na imagem abaixo:
![[Pasted image 20260512110449.png]]


Análise da IA com base na reunião com o Michel sobre o problema:

# Anotações da reunião

### Gestão de grupos e integrações

- Felipe explicou que o usuário é incluído no grupo no AD corretamente, mas o Okta não envia o grupo para a OCI, apesar de estar mapeado e seguir o padrão dos demais grupos.
- Michel confirmou que a criação e configuração do grupo seguem o mesmo padrão dos outros grupos, e que a integração do AD com a OCI está funcionando para os demais.
- Felipe pediu para Michel mostrar o processo de configuração dos grupos no Okta para verificar possíveis diferenças.
- Michel explicou que, ao criar um grupo local no Okta, é possível configurar uma regra para que os usuários do grupo do AD sejam transferidos para esse grupo local, permitindo que a aplicação utilize o grupo do Okta em vez do AD.
- Felipe confirmou que, ao solicitar acesso pelo Savepoint, o usuário já é incluído automaticamente no grupo correspondente do Okta, seguindo o processo descrito por Michel.
- Felipe informou que criou o grupo OK na OCF e configurou no identity provider para receber usuários do Okta e do Central.
- Felipe confirmou que o usuário Wellington foi incluído manualmente no grupo digital, pois não estava sendo transferido automaticamente.
- Felipe sugeriu acompanhar os logs para verificar se o Okta está enviando corretamente as informações para o Central e como o Central responde.
- Felipe e Michel discutiram que o grupo do Okta deve ter o mesmo nome do grupo na OCI para garantir o mapeamento correto, especialmente para grupos como "BR" ou "Credit Group Digital".
- Felipe questionou se existe algum campo no Okta para mapear grupos específicos para a OCI, e Michel explicou que cada aplicação pode ter um formato diferente, mas normalmente o nome do grupo é utilizado.
- Michel levantou a dúvida sobre o motivo de apenas um grupo não estar funcionando corretamente, enquanto os demais seguem o padrão e funcionam.
- Felipe e Michel testaram a atualização dos grupos no Okta para verificar se o grupo "digital" aparecia corretamente após o refresh.
- Michel removeu e incluiu usuários nos grupos do AD para testar a sincronização com o Okta e a transferência para a OCI.
- Felipe explicou que ao remover e adicionar novamente o João ao grupo do AD, o Okta deveria reconhecer e enviar o usuário para a OCI, criando ou atualizando o grupo conforme esperado.
- Michel incluiu o João no grupo do AD, mas informou que a replicação para o Okta ainda não ocorreu, possivelmente devido ao tempo de processamento.
- Felipe e Michel decidiram aguardar algumas horas para verificar se o AD irá transferir o usuário para o Okta e se o Okta criará o usuário no grupo da OCI.
- Felipe sugeriu que, caso a replicação não ocorra, irá comunicar Michel pelo chat para que possam investigar juntos.

# Tarefas de acompanhamento

|Tarefa|Atribuído a|Data de conclusão|Balde|
|---|---|---|---|
|Confirmar se a ativação do grupo local no Okta foi realizada corretamente (Michel)||||