Ajudar na rotação dos certificados internos, já que a Root CA foi atualizada e todos os certs expiram em 28/06/2027.

**Divisão de trabalho (Wellington + Felipe):**


- [ ] Fazer identificação do que cada certificado da planilha pertence
- [ ] Chamar o Wellington para ajudar na separação do que é nosso (separar o que é nosso em outra página)
- [ ] Wellington vai **me mostrar como emitir** o certificado pela minha máquina
- Após o tutorial, eu começo a emitir os certificados sozinho
- Ritmo proposto: **3–4 certificados por semana**, começando pelos de não produção
- Certificados críticos (Kafka, Redis) ficam para o final — vão precisar de **Change** aberta

**Exemplos de certs que vão entrar no escopo:**

- Rancher, Argo, Dragonfly, Keycloak
- Wildcard `*.prd.oke` (Thiago já associou um)
- Kafka (nominal — envolve devs depois)
- Meta: terminar todas as rotações **até o final de 2026**