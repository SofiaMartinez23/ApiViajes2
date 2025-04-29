using ApiViajes.Data;
using Microsoft.EntityFrameworkCore;
using NugetViajesSMG.Models;

namespace ApiViajes.Repositories
{
    public class RepositorySeguidos
    {

        private ViajesContext context;

        public RepositorySeguidos(ViajesContext context)
        {
            this.context = context;
        }

        public async Task<List<UsuarioSeguidoPerfil>> GetSeguidoresAsync(int usuarioId)
        {
            return await this.context.UsuarioSeguidoPerfiles
                .Where(s => s.IdUsuarioSeguidor == usuarioId).ToListAsync();
        }

        public async Task<List<UsuarioSeguidoPerfil>> GetSeguidosAsync(int usuarioId)
        {
            return await this.context.UsuarioSeguidoPerfiles
                .Where(s => s.IdUsuarioSeguido == usuarioId).ToListAsync();
        }
        public async Task<UsuarioSeguidoPerfil> FindSeguidosAsync(int usuarioId)
        {
            return await this.context.UsuarioSeguidoPerfiles.FirstOrDefaultAsync(x => x.IdUsuarioSeguido == usuarioId);
        }

        public async Task<List<int>> GetIdsSeguidosPorUsuarioAsync(int idUsuario)
        {
            var ids = await this.context.Seguidores
                .Where(s => s.IdUsuarioSeguidor == idUsuario)
                .Select(s => s.IdUsuarioSeguido)
                .ToListAsync();

            return ids;
        }


        public async Task InsertSeguidorAsync(int usuarioSeguidorId, int usuarioSeguidoId)
        {
            var maxId = await this.context.Seguidores.MaxAsync(s => (int?)s.IdSeguidor) ?? 0;

            Seguidor seg = new Seguidor();
            seg.IdSeguidor = maxId + 1;
            seg.IdUsuarioSeguidor = usuarioSeguidorId;
            seg.IdUsuarioSeguido = usuarioSeguidoId;
            seg.FechaSeguimiento = DateTime.UtcNow;

            await this.context.Seguidores.AddAsync(seg);
            await this.context.SaveChangesAsync();
        }


        public async Task DeleteSeguidorAsync(int seguidoId)
        {
            Seguidor seguidor = await this.context.Seguidores
                .FirstOrDefaultAsync(s => s.IdUsuarioSeguido == seguidoId);

            this.context.Seguidores.Remove(seguidor);
            await this.context.SaveChangesAsync();
        }

    }
}
