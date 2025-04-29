using ApiViajes.Data;
using ApiViajes.Helpers;
using ApiViajes.Repositories;
using Microsoft.Extensions.Azure;
using Microsoft.EntityFrameworkCore;
using Azure.Security.KeyVault.Secrets;
using Azure.Storage.Blobs;

var builder = WebApplication.CreateBuilder(args);

// Configurar acceso a KeyVault
builder.Services.AddAzureClients(factory =>
{
    factory.AddSecretClient(builder.Configuration.GetSection("KeyVault"));
});

// Obtener los secretos
SecretClient secretClient = builder.Services.BuildServiceProvider().GetRequiredService<SecretClient>();

KeyVaultSecret secretSqlAzure = await secretClient.GetSecretAsync("SqlAzure");
KeyVaultSecret secretStorageAccount = await secretClient.GetSecretAsync("StorageAccount");

KeyVaultSecret secretAudience = await secretClient.GetSecretAsync("Audience");
KeyVaultSecret secretIssuer = await secretClient.GetSecretAsync("Issuer");
KeyVaultSecret secretIterate = await secretClient.GetSecretAsync("Iterate");
KeyVaultSecret secretKey = await secretClient.GetSecretAsync("Key");
KeyVaultSecret secretSalt = await secretClient.GetSecretAsync("Salt");
KeyVaultSecret secretSecretKey = await secretClient.GetSecretAsync("SecretKey");

// Inicializar HelperCryptography
HelperCryptography.Initialize(
    secretSalt.Value,
    secretIterate.Value,
    secretKey.Value
);

builder.Services.AddHttpContextAccessor();

// Configurar HelperActionServicesOAuth
HelperActionServicesOAuth helper = new HelperActionServicesOAuth(
    secretIssuer.Value,
    secretAudience.Value,
    secretSecretKey.Value
);
builder.Services.AddSingleton<HelperActionServicesOAuth>(helper);

// Configurar autenticación JWT
builder.Services.AddAuthentication(helper.GetAuthenticateSchema())
    .AddJwtBearer(helper.GetJwtBearerOptions());

// Registrar servicios y repositorios
builder.Services.AddScoped<HelperUsuarioToken>();
builder.Services.AddTransient<RepositoryAuth>();
builder.Services.AddTransient<RepositoryUsuarios>();
builder.Services.AddTransient<RepositoryLugar>();
builder.Services.AddTransient<RepositoryComentarios>();
builder.Services.AddTransient<RepositoryChats>();
builder.Services.AddTransient<RepositoryFavoritos>();
builder.Services.AddTransient<RepositorySeguidos>();

// Configurar DbContext
string connectionString = secretSqlAzure.Value;
builder.Services.AddDbContext<ViajesContext>(options =>
    options.UseSqlServer(connectionString));

// Configurar Blob Storage
string azureKeys = secretStorageAccount.Value;
BlobServiceClient blobServiceClient = new BlobServiceClient(azureKeys);
builder.Services.AddTransient<BlobServiceClient>(x => blobServiceClient);

// Controllers y OpenAPI
builder.Services.AddControllers();
builder.Services.AddOpenApi();

var app = builder.Build();

// Configurar pipeline de la app
if (app.Environment.IsDevelopment())
{
    // Solo en desarrollo
}

app.MapOpenApi();
app.UseHttpsRedirection();

app.UseSwaggerUI(options =>
{
    options.SwaggerEndpoint("/openapi/v1.json", "Api Viajes");
    options.RoutePrefix = "";
});

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

app.Run();
