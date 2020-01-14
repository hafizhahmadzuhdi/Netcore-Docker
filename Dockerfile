FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY *.sln .
COPY simple/*.csproj ./simple/
RUN dotnet restore

# Copy everything else and build
COPY simple/. ./simple/
WORKDIR /app/simple
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:2.2
WORKDIR /app
COPY --from=build /app/simple/out ./
ENTRYPOINT ["dotnet", "simple.dll"]