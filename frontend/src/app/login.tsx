import { Button } from "src/components/ui/button"
import { Input } from "src/components/ui/input"
import { Label } from "src/components/ui/label"
import React, {useState} from 'react';
import {signIn} from "../lib/authService";

export default function Login() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");

  const handleSignIn = async (e: { preventDefault: () => void }) => {
    e.preventDefault();
    try {
      const session = await signIn(email, password);
      console.log("Sign in successful", session);
      if (session && typeof session.AccessToken !== "undefined") {
        sessionStorage.setItem("accessToken", session.AccessToken);
        if (sessionStorage.getItem("accessToken")) {
          window.location.href = "/home";
        } else {
          console.error("Session token was not set properly.");
        }
      } else {
        console.error("SignIn session or AccessToken is undefined.");
      }
    } catch (error) {
      alert(`Sign in failed: ${error}`);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-green-50">
      <div className="bg-white p-8 rounded-lg shadow-md w-96">
        <h1 className="text-3xl font-bold mb-6 text-center text-green-800">PlantApp</h1>
        <form className="space-y-4" onSubmit={handleSignIn}>
          <div className="space-y-2">
            <Label htmlFor="email" className="text-green-700">Correo electrónico</Label>
            <Input
                id="email"
                type="email"
                placeholder="tu@email.com"
                required
                className="border-green-300 focus:border-green-500 focus:ring-green-500"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
            />
          </div>
          <div className="space-y-2">
            <Label htmlFor="password" className="text-green-700">Contraseña</Label>
            <Input
                id="password"
                type="password"
                required
                className="border-green-300 focus:border-green-500 focus:ring-green-500"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
            />
          </div>
          <Button type="submit" className="w-full bg-green-600 hover:bg-green-700 text-white">
            Iniciar sesión
          </Button>
        </form>
        <div className="mt-4 text-center text-sm text-green-600">
          ¿No tienes una cuenta?{" "}
          <a href="/signup" className="underline hover:text-green-800">
            Regístrate
          </a>
        </div>
      </div>
    </div>
  )
}