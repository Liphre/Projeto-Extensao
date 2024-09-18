# FAMÍLIA CONECTADA
## Sistema de Monitoramento Escolar

## Descrição do Projeto

Este projeto é uma aplicação desenvolvida em Python utilizando a biblioteca PyQt5, que permite aos pais monitorar o desempenho escolar de seus filhos. A aplicação oferece funcionalidades como visualização de notas, horários de aulas e um calendário de atividades escolares. O sistema se conecta a um banco de dados MySQL para armazenar e recuperar informações.

## Funcionalidades

- **Tela de Login e Registro**: Permite que os pais se registrem e acessem a plataforma.
- **Visualização de Notas**: Os pais podem acessar o boletim escolar dos filhos.
- **Horários de Aula**: Informações sobre os horários das aulas são apresentadas.
- **Calendário de Atividades**: Os pais podem visualizar as atividades programadas na escola.

## Tecnologias Utilizadas

- Python
- PyQt5
- MySQL
- WAMP Server

## Estrutura do Código

- **Banco de Dados**: O sistema utiliza MySQL para armazenar informações sobre pais, alunos e eventos escolares.
- **Interface Gráfica**: Desenvolvida com PyQt5, permitindo uma interação amigável e intuitiva.
- **Funções Principais**: O código inclui funções para manipular dados, conectar-se ao banco de dados e atualizar a interface do usuário.

## Instruções de Uso

1. **Configuração do Banco de Dados**: Certifique-se de que o WAMP Server esteja em execução e o banco de dados `sistema_escola` esteja criado.
2. **Instalação das Dependências**: Instale as bibliotecas necessárias com o comando:
   ```bash
   pip install PyQt5 mysql-connector-python
