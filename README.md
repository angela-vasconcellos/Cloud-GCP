<h1 align="center">DESAFIO 3 - INSFRAESTRUTURA POR CÓDIGO</h1>

<p align="justify">Criação de Infraestrutura por código no GCP, a fim de executar as APIs construídas no desafio 1.</p>


<h2>OBJETIVO</h2>

- O objetivo do desafio é criar uma infraestrutura de rede e após, rodar a aplicação realizada no desafio 1.
- Para realização do desafio, utilizamos o Terraform e como provedor, o GCP (Google Cloud).

<h2>FERRAMENTAS UTILIZADAS</h2>

- <b>Terraform</b> como ferramenta para construção, manutenção e versionamento de infraestrutura.
- <b>Google Cloud - GCP</b> como provedor na nuvem.
- <b>Python</b> como linguagem de programação para montagem das APIs referentes ao desafio 1.

<h2>RECURSOS UTILIZADOS NO GCP</h2>

- [X] VPC Network + Subnetwork 
- [X] Cloud router
- [X] NAT Gateway
- [X] Route Tables
- [X] Instance Group
- [X] Load Balance
- [X] Health Check
- [X] Backend service
- [X] Instance Template
- [X] Auto Scalling
- [X] Firewall Rules
- [X] SQL (banco de dados)
- [X] Bucket

<h2>PARTE 1 - MONTAGEM DA INFRAESTRUTURA</h2>


1. Criação da <b>VPC</b> e com ela foram criadas 3 subnetworks, sendo 2 públicas e 1 privada.
    Na subnetwork privada está a aplicação.
    Nas subnetworks públicas estão o Bastion Host em uma e na outra, está o Load Balance e Auto Scalling.
    Todos os recursos foram criados com zonas múltiplas, a fim de termos uma alta disponibilidade.

2. :warning: A criação do <b>IGW</b> é automática, não sendo necessário nenhuma ação.

3. Após, criamos o <b>Cloud Router e o NAT</b> para a subnetwork privada, possibilitando o acesso para a internet. Vale mencionar que, no GCP as route tables são automáticas e a associação do NAT também.

4. :warning: Outra diferença importante entre AWS e GCP é que, <b>no GCP não é possível restringir a zona na subnet</b>, mas tão somente nos recursos ou direto na VPC, o que não é interessante caso queira tornar o recurso multi zonal, como por exemplo, na criação das instâncias. Então é possível utilizar uma única subnet para deixar os seus recursos com alta disponibilidade, lembrando que todas as zonas devem pertencem a mesma região definida na VPC e subnet.

5. Criação uma instância para o <b>Bastion Host</b>, a partir dela, temos acesso externo (para a internet). É uma máquina pública e, através dela acessamos as máquinas privadas e o banco de dados.


<br><br>


<h2>PARTE 2 - DEPLOY DA APLICAÇÃO</h2>

1. :heavy_check_mark: Com a conclusão da Infraestrutura, seguimos para a montagem do Auto Scalling e do Load Balance.

2. Montamos o <b>Auto Scalling</b>, possbilitando alta escalabilidade da aplicação. O objetivo do Auto Scalling é permitir o aumento e diminuição automático de máquinas virtuais de acordo com a necessidade das aplicações, com base em situações definidas, como níveis de utilização da CPU.

3. :warning: No GCP, o <b>Load Balance</b> funciona um pouco diferente da AWS. Nele, é necessário antes de tudo, escolher a melhor opção de Load Balance para sua necessidade, sendo elas: HTTP, TCP e UDP.

4. Para o nosso desafio, escolhemos HTTP. Para a criação, precisamos antes, criar outros recursos que ficarão atrelados ao Load Balance, quais sejam: <b>Frontend, Backend Service, Health Check, Instance Template e Instance Group, além das regras de firewall necessárias para o health check</b>.

5. Com o <b>Load Balance</b> criado, temos um IP público que tornará possível que o conteúdo da máquina privada (API) rode no navegador. Além disso, o <b>objetivo do Load</b> que nada mais é do que um balanceador de carga, ou seja, é utilizado para manter a estabilidade de um servidor quando o tráfego ou o volume de dados é muito grande, evitando que seu site fique lento ou caia.

6. Após, criamos o recurso do <b>SQL</b>, o qual não é vinculado a uma subnetwork no GCP e acessamos o MySQl atráves do Bastion Host, criando o banco de dados e inserindo as informações.

7. Por fim, inserimos as <b>APis</b> dentro das máquinas privadas, instalamos todos os pacotes necessários (python, mysql, pip, flask e flask-mysqldb). Com tudo instalado, podemos rodar o arquivo python e visualizar no navegador.


ex3.PNG
