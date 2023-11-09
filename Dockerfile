FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /p3ops-demo-app

# Copy everything
COPY . ./
# Restore as distinct layers
RUN dotnet restore src/Server/Server.csproj
# Build and publish a release
RUN dotnet publish src/Server/Server.csproj -c Release -o publish

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /p3ops-demo-app
COPY --from=build-env /p3ops-demo-app/publish .
ENTRYPOINT ["dotnet", "Server.dll"]

#Expose ports
EXPOSE 80
