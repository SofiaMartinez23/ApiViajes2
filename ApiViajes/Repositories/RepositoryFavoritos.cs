using ApiViajes.Data;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using NugetViajesSMG.Models;

namespace ApiViajes.Repositories
{
    public class RepositoryFavoritos
    {
        private ViajesContext context;

        public RepositoryFavoritos(ViajesContext context)
        {
            this.context = context;
        }
        public async Task<List<LugarFavorito>> GetFavoritosAsync()
        {
            return await this.context.LugaresFavoritos.ToListAsync();
        }

        public async Task<List<int>> GetIdsLugaresFavoritosPorUsuarioAsync(int idUsuario)
        {
            var ids = await this.context.LugaresFavoritos
                .Where(f => f.IdUsuario == idUsuario)
                .Select(f => f.IdLugar)
                .ToListAsync();

            return ids;
        }


        public async Task<List<LugarFavorito>> FindFavoritosLugarAsync(int idUsuario)
        {
            return await this.context.LugaresFavoritos
                .Where(x => x.IdUsuario == idUsuario)
                .ToListAsync();
        }


        public async Task<bool> ExisteFavoritoAsync(int idUsuario, int idLugar)
        {
            var favorito = await this.context.LugaresFavoritos
                .FirstOrDefaultAsync(f => f.IdUsuario == idUsuario && f.IdLugar == idLugar);

            return favorito != null;
        }

        public async Task InsertFavoritoAsync(int idFavorito, int idUsuario, int idLugar, DateTime fecha, string imagen, string nombre, string descripcion, string ubicacion, string tipo)
        {

            LugarFavorito favorito = new LugarFavorito();
            favorito.IdFavorito = idFavorito;
            favorito.IdUsuario = idUsuario;
            favorito.IdLugar = idLugar;
            favorito.FechaDeVisitaLugar = fecha;
            favorito.ImagenLugar = imagen;
            favorito.NombreLugar = nombre;
            favorito.DescripcionLugar = descripcion;
            favorito.UbicacionLugar = ubicacion;
            favorito.TipoLugar = tipo;
            

            await this.context.LugaresFavoritos.AddAsync(favorito);
            await this.context.SaveChangesAsync();
        }

        public async Task DeleteFavoritoAsync( int idLugar)
        {
            LugarFavorito fav = await this.context.LugaresFavoritos
                .FirstOrDefaultAsync(s => s.IdLugar == idLugar);

            this.context.LugaresFavoritos.Remove(fav);
            await this.context.SaveChangesAsync();
        }



    }
}
