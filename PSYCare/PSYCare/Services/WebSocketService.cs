

using System.Collections.Concurrent;
using System.Net.WebSockets;

namespace PSYCare.Services
{
    public interface IWebSocketService
    {
        void Add(int psychologistId, WebSocket socket);
        void Remove(int psychologistId);
        bool TryGet(int psychologistId, out WebSocket socket);
    }

    public class WebSocketService : IWebSocketService
    {
        private readonly ConcurrentDictionary<int, WebSocket> _sockets = new();

        public void Add(int psychologistId, WebSocket socket) => _sockets[psychologistId] = socket;

        public void Remove(int psychologistId) => _sockets.TryRemove(psychologistId, out _);

        public bool TryGet(int psychologistId, out WebSocket socket) => _sockets.TryGetValue(psychologistId, out socket);
    }
}
