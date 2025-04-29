using ApiViajes.Data;
using Microsoft.EntityFrameworkCore;
using NugetViajesSMG.Models;

namespace ApiViajes.Repositories
{
    public class RepositoryAuth
    {
        private ViajesContext context;

        public RepositoryAuth(ViajesContext context)
        {
            this.context = context;
        }

        public async Task<UsuarioCompletoView> LogInUsuarioAsync(string correo, string clave)
        {
            return await this.context.UsuarioCompletoViews
                .Where(x => x.Email == correo && x.Clave == clave)
                .FirstOrDefaultAsync();
        }

    }
}
