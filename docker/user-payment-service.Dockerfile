FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY lisa-user-payment-service/NuGet.Config ./
COPY lisa-user-payment-service/ProjectLucy.API/ProjectLucy.API.csproj ProjectLucy.API/
COPY lisa-user-payment-service/ProjectLucy.Application/ProjectLucy.Application.csproj ProjectLucy.Application/
COPY lisa-user-payment-service/ProjectLucy.Domain/ProjectLucy.Domain.csproj ProjectLucy.Domain/
COPY lisa-user-payment-service/ProjectLucy.Infrastructure/ProjectLucy.Infrastructure.csproj ProjectLucy.Infrastructure/
COPY lisa-user-payment-service/ProjectLucy.Shared/ProjectLucy.Shared.csproj ProjectLucy.Shared/

RUN dotnet restore ProjectLucy.API/ProjectLucy.API.csproj

COPY lisa-user-payment-service/. ./
RUN dotnet publish ProjectLucy.API/ProjectLucy.API.csproj -c Release -o /app/publish /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS runtime
WORKDIR /workspace

ENV PATH="$PATH:/root/.dotnet/tools"
RUN dotnet tool install --global dotnet-ef --version 8.*

COPY --from=build /src ./
COPY --from=build /app/publish /app/publish
COPY lisa-infra/docker/user-payment-service-start.sh /usr/local/bin/user-payment-service-start.sh

RUN chmod +x /usr/local/bin/user-payment-service-start.sh

EXPOSE 5000

CMD ["/usr/local/bin/user-payment-service-start.sh"]
