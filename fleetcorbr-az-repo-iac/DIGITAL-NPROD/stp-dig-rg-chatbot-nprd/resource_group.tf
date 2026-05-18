module "rg" {
  source = "../../MODULES/resource_groups"

  resource_group_name = "stp-dig-rg-chatbot-nprd"
  location            = "brazilsouth"

  tags = {
    Projeto = "Super Carol"
  }
}