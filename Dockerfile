# Usa la imagen oficial de .NET para construir la aplicaci�n
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080

# Etapa de construcci�n
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copiar solo el archivo del proyecto (.csproj) desde la ra�z
COPY ["PayMeChat_V_1.csproj", "./"]

# Restaurar las dependencias
RUN dotnet restore "PayMeChat_V_1.csproj"

# Copiar todo el c�digo fuente
COPY . .
RUN dotnet build "PayMeChat_V_1.csproj" -c Release -o /app/build

# Publicar la aplicaci�n
FROM build AS publish
RUN dotnet publish "PayMeChat_V_1.csproj" -c Release -o /app/publish

# Imagen final con la app publicada
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

# Establecer la variable de entorno PORT (Render usa esto autom�ticamente)
ENV ASPNETCORE_URLS=http://+:8080
ENTRYPOINT ["dotnet", "PayMeChat_V_1.dll"]
