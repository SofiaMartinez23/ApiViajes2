using ApiViajes.Data;
using NugetViajesSMG.Models;
using Microsoft.EntityFrameworkCore;

namespace ApiViajes.Repositories
{
    public class RepositoryUsuarios
    {
        private ViajesContext context;

        public RepositoryUsuarios(ViajesContext context)
        {
            this.context = context;
        }

        public async Task<List<UsuarioCompletoView>> GetUsuariosAsync()
        {
            return await this.context.UsuarioCompletoViews.ToListAsync();
        }

        public async Task<UsuarioCompletoView> FindUsuarioAsync(int idUsuario)
        {
            return await this.context.UsuarioCompletoViews
                .FirstOrDefaultAsync(z => z.IdUsuario == idUsuario);
        }
        public async Task<List<UsuarioCompletoView>> FindUsuariosByNameAsync(string searchTerm)
        {
            if (string.IsNullOrEmpty(searchTerm))
            {
                return new List<UsuarioCompletoView>();
            }

            string lowerSearchTerm = searchTerm.ToLower();

            return await this.context.UsuarioCompletoViews
                .Where(u => u.Nombre.ToLower().Contains(lowerSearchTerm))
                .ToListAsync();
        }

        public async Task<UsuarioCompletoView> GetUsuarioPerfilAsync(int idUsuario)
        {
            return await this.context.UsuarioCompletoViews
                .FirstOrDefaultAsync(u => u.IdUsuario == idUsuario);
        }

        public async Task InsertUsuarioAsync(int idUsuario, string nombre, string email,
          int edad, string nacionalidad, string preferenciaviaje, string clave, string confirmarclave, string imagen)
        {
            UsuarioCompletoView user = new UsuarioCompletoView();
            user.IdUsuario = idUsuario;
            user.Nombre = nombre;
            user.Email = email;
            user.Edad = edad;
            user.Nacionalidad = nacionalidad;
            user.PreferenciaViaje = preferenciaviaje;
            user.Clave = clave;
            user.ConfirmarClave = confirmarclave;
            user.AvatarUrl = imagen;
            user.FechaRefistro = DateTime.Now;


            await this.context.UsuarioCompletoViews.AddAsync(user);
            await this.context.SaveChangesAsync();
        }

        public async Task UpdateUsuarioAsync(int idUsuario, string nombre, string email, int edad, string nacionalida,
            string preferencia, string clave, string configuracionclave, string avatarurl)
        {
            UsuarioCompletoView usuario = await this.FindUsuarioAsync(idUsuario);
            usuario.IdUsuario = idUsuario;
            usuario.Nombre = nombre;
            usuario.Email = email;
            usuario.Edad = edad;
            usuario.Nacionalidad = nacionalida;
            usuario.PreferenciaViaje = preferencia;
            usuario.Clave = clave;
            usuario.ConfirmarClave = configuracionclave;
            usuario.AvatarUrl = avatarurl;
            usuario.FechaRefistro = DateTime.Now;

            await this.context.SaveChangesAsync();

        }
    }
}
