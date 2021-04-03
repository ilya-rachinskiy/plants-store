FROM mcr.microsoft.com/dotnet/aspnet:5.0.4-buster-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0.201-buster-slim AS build
# WORKDIR /src/core
COPY ["/src/core/PlantsStore/PlantsStore/PlantsStore.csproj", "PlantsStore/"]
RUN dotnet restore "PlantsStore/PlantsStore.csproj"
COPY . .
RUN ls
RUN dotnet build "/src/core/PlantsStore/PlantsStore/PlantsStore.csproj" -c Development -o /app/build

FROM build AS publish
RUN dotnet publish "/src/core/PlantsStore/PlantsStore/PlantsStore.csproj" -c Development -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "PlantsStore.dll"]