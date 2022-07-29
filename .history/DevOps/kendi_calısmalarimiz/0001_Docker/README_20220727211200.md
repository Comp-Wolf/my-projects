# 1-) Cloudformation ile Docker için EC2 ayağa kaldıralım.

# 2-) Ayağa kalkan makinemizin security grubunda inbound rules'a all traffic'i ekleyelim.

# 3-) Aşağıdaki komutlarla docker ve docker-compose'un yüklü olup olmadığını kontrol edelim.

    docker --version
    docker-compose --version

# 4-) .NET yüklemek için aşağıdaki komutları koşturalım.

    sudo rpm -Uvh https://packages.microsoft.com/config/centos/7/packages-microsoft-prod.rpm
    sudo yum install dotnet-sdk-6.0

# 5-) Example isimli bir klasör oluşturup içerisine .NET framework'ü için belirtilen şablonu temel alan yeni bir proje oluşturalım.

    dotnet new mvc

# 6-) Aşağıdaki komutu çalıştırdığımızda uygulamamıza browser üzerinden direkt olarak ulaşabiliyoruz.

    dotnet run

# 7-) Dockerfile oluşturalım.

---
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 5080

ENV ASPNETCORE_URLS=http://+:5080

# Creates a non-root user with an explicit UID and adds permission to access the /app folder
# For more info, please refer to https://aka.ms/vscode-docker-dotnet-configure-containers
RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /app
USER appuser

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["Example.csproj", "./"]
RUN dotnet restore "Example.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "Example.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Example.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Example.dll"]
---

# 8-) Aşağıdaki komutla Dockerfile dosyamızdan bir docker image oluşturalım.

    docker image build -t example .

# 9-) İmajımızın oluştuğunu kontrol etmek için aşağıdaki komutu koşturalım.

    docker images

# 10-) Oluşan image ile container oluşturalım.

    docker container run --name test-container -d -p 6080:5080 example

# 11-) Tarayıcımızdan "PublicIPofEC2:6080" adresini açıp uygulamamızı görelim.

# 12-) Aynı uygulamayı bu sefer docker compose ile ayağa kaldıralım. Bunun için docker-compose.yml dosyası oluşturalım.

---
version: '3.4'

services:
  example:
    image: example
    build:
      context: .
      dockerfile: ./Dockerfile
    ports:
      - 7080:5080
---

# 13-) Docker compose dosyasının çalışması için aşağıdaki komutu koşturalım ve 7080 portundan uygulamamızı açalım.

    docker-compose up 

# 14-) Uygulamamıza ait IP adresine ulaşmak için aşağıdaki komutu koşturalım ve o IP adresiyle de uygulamamızı açalım.

    docker container inspect test-container