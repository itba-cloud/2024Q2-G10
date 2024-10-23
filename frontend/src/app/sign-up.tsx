import { Button } from "src/components/ui/button"
import { Input } from "src/components/ui/input"
import { Label } from "src/components/ui/label"
import React, { useState } from 'react';
import {Link, useNavigate} from "react-router-dom";
import {signUp} from "../lib/authContext";

export default function Signup() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const navigate = useNavigate();


  const validatePassword = (password: string): string[] => {
    const errors: string[] = [];

    if (password.length < 8) {
      errors.push("La contraseña debe tener al menos 8 caracteres.");
    }

    if (!/\d/.test(password)) {
      errors.push("La contraseña debe contener al menos un número.");
    }

    if (!/[!@#$%^&*(),.?":{}|<>]/.test(password)) {
      errors.push("La contraseña debe contener al menos un carácter especial.");
    }

    if (!/[A-Z]/.test(password)) {
      errors.push("La contraseña debe contener al menos una letra mayúscula.");
    }

    if (!/[a-z]/.test(password)) {
      errors.push("La contraseña debe contener al menos una letra minúscula.");
    }

    return errors;
  };

  const handleSignUp = async (e: { preventDefault: () => void }) => {
    e.preventDefault();

    const errors = validatePassword(password);

    if (errors.length > 0) {
      const formattedErrors = errors.map(error => `- ${error}`).join('\n');
      alert("Errores: \n" + formattedErrors)
      return;
    }

    if (password !== confirmPassword) {
      alert("Passwords do not match");
      return;
    }
    try {
      await signUp(email, password);
      navigate("/confirm", { state: { email } });
    } catch (error) {
      alert(`Sign up failed: ${error}`);
    }
  };


  return (
    <div className="min-h-screen flex items-center justify-center bg-green-50">
      <div className="bg-white p-8 rounded-lg shadow-md w-96">
        <h1 className="text-3xl font-bold mb-6 text-center text-green-800">PlantApp</h1>
        <form className="space-y-4">
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
          <div className="space-y-2">
            <Label htmlFor="confirm-password" className="text-green-700">Confirmar contraseña</Label>
            <Input
                id="confirm-password"
                type="password"
                required
                className="border-green-300 focus:border-green-500 focus:ring-green-500"
                value={confirmPassword}
                onChange={(e) => setConfirmPassword(e.target.value)}
            />
          </div>
          <Button type="submit" onClick={handleSignUp} className="w-full bg-green-600 hover:bg-green-700 text-white">
            Registrarse
          </Button>
        </form>
        <div className="mt-4 text-center text-sm text-green-600">
          ¿Ya tienes una cuenta?{" "}
          <Link to="/login" className="underline hover:text-green-800">
            Inicia sesión
          </Link>
        </div>
      </div>
    </div>
  )
}