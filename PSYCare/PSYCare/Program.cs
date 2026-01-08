using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using PSYCare.Database;
using PSYCare.Services;
using PSYCare.Services.Interfaces;
using System.Net.WebSockets;


var builder = WebApplication.CreateBuilder(args);

builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
    {
        policy.WithOrigins("http://localhost:5173") 
              .AllowAnyHeader()
              .AllowAnyMethod();
    });
});

builder.Services.AddDbContext<PSYCareDbContext>(options =>
    options.UseNpgsql(builder.Configuration.GetConnectionString("DefaultConnection")));

builder.Services.AddScoped<IAuthService, AuthService>();
builder.Services.AddScoped<IPatientsService, PatientsService>();
builder.Services.AddScoped<IPsychologistsService, PsychologistsService>();
builder.Services.AddScoped<IMoodService, MoodService>();
builder.Services.AddSingleton<IWebSocketService, WebSocketService>();

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
var app = builder.Build();


app.UseWebSockets(); // activeaz? WebSocket

var webSocketClients = new Dictionary<int, WebSocket>(); // PsychologistId -> WebSocket

app.Map("/ws", async context =>
{
    if (context.WebSockets.IsWebSocketRequest)
    {
        var wsManager = context.RequestServices.GetRequiredService<IWebSocketService>();
        var webSocket = await context.WebSockets.AcceptWebSocketAsync();

        var psychologistIdStr = context.Request.Query["psychologistId"];
        if (!int.TryParse(psychologistIdStr, out int psychologistId))
        {
            await webSocket.CloseAsync(WebSocketCloseStatus.InvalidPayloadData, "Invalid ID", CancellationToken.None);
            return;
        }

        wsManager.Add(psychologistId, webSocket);

        var buffer = new byte[1024 * 4];
        while (webSocket.State == WebSocketState.Open)
        {
            var result = await webSocket.ReceiveAsync(new ArraySegment<byte>(buffer), CancellationToken.None);

            if (result.MessageType == WebSocketMessageType.Close)
            {
                wsManager.Remove(psychologistId);
                await webSocket.CloseAsync(WebSocketCloseStatus.NormalClosure, string.Empty, CancellationToken.None);
            }
        }
    }
});

app.UseCors();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
