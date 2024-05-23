import { useState } from "react";
import { client } from "../supabase/client";

export default function Signup() {
     const [email, setEmail] = useState('');
     const [password, setPassword] = useState('');

     const handleSubmit = async (e) => {
          e.preventDefault();
          try {
               const result = await client.auth.signUp({
                    email: email,
                    password: password,
               });
               console.log(result);
          } catch (error) {
               console.log(error);
          }
     };

     return (
          <div>
               <form onSubmit={handleSubmit}>
                    <input
                         type="email"
                         name="email"
                         placeholder="Introduce aqui tu correo"
                         onChange={(e) => setEmail(e.target.value)}
                    />

                    <input
                         type="password"
                         name="password"
                         placeholder="Introduce aqui tu contraseña"
                         onChange={(e) => setPassword(e.target.value)}
                    />
                    <button>Send</button>
               </form>
          </div>
     );
}
