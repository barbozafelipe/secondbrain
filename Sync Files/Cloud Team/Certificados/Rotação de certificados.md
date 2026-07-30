Ajudar na rotação dos certificados internos, já que a Root CA foi atualizada e todos os certs expiram em 28/06/2027.

**Divisão de trabalho (Wellington + Felipe):**


- [x] Fazer identificação do que cada certificado da planilha pertence
- [x] Chamar o Wellington para ajudar na separação do que é nosso (separar o que é nosso em outra página)
- [ ] Wellington vai **me mostrar como emitir** o certificado pela minha máquina
- Após o tutorial, eu começo a emitir os certificados sozinho
- Ritmo proposto: **3–4 certificados por semana**, começando pelos de não produção
- Certificados críticos (Kafka, Redis) ficam para o final — vão precisar de **Change** aberta

**Exemplos de certs que vão entrar no escopo:**

- Rancher, Argo, Dragonfly, Keycloak
- Wildcard `*.prd.oke` (Thiago já associou um)
- Kafka (nominal — envolve devs depois)
- Meta: terminar todas as rotações **até o final de 2026**

Planilha com certificados:
[Certificados_CAROOT.xlsx](https://fleetcor-my.sharepoint.com/:x:/r/personal/ithallo_nunes_corpay_com_br/Documents/Arquivos%20de%20Chat%20do%20Microsoft%20Teams/Certificados_CAROOT.xlsx?d=wde4f82082f2246e8af2faaa4a96a79f2&csf=1&web=1&e=Qt3Rlk)
