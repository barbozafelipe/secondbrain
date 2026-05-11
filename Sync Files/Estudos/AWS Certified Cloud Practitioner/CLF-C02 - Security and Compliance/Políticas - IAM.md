
==Políticas baseadas em identidade (Identity-based policies)==

Uma entidade pode ser um usuário, grupo ou role, em resumo:
Permissões anexadas a um usuário, grupo ou role.


Policy: São criadas primeiramente sendo totalmente personalizada por mim ou utilizado outras já criadas pela AWS. Sendo personalizada por mim ou pela AWS, ali teremos descritas as permissões, ao salvar, teremos uma Policy. Podemos atachá-la em grupos, usuários e em Role.

Inline Policy: É a mesma coisa que a Policy, pórém só pode ser criada atachando direto em grupos, usuários ou Role. Não pode ser criada e deixada orfã igual a Policy padrão.

Role: São criadas a apartir de um tipo, precisamos escolher quem pode assumir essa Role, no caso de escolher um serviço da AWS, eu escolhi que seria EC2, pronto, criado. Para ter alguma função eu preciso atachar uma Policy nela.

![[Pasted image 20260511154633.png]]
