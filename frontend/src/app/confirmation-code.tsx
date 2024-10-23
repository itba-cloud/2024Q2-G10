import { Button } from "src/components/ui/button"
import { Input } from "src/components/ui/input"
import { Label } from "src/components/ui/label"
import React, {useState} from 'react';
import {confirmSignUp} from "../lib/authService";
import {useLocation, useNavigate} from "react-router-dom";

export default function ConfirmUserPage() {

  const navigate = useNavigate();
  const location = useLocation();
  const [email, setEmail] = useState(location.state?.email || "");
  const [confirmationCode, setConfirmationCode] = useState("");

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    try {
      await confirmSignUp(email, confirmationCode);
      alert("Account confirmed successfully!\nSign in on next page.");
      navigate("/login");
    } catch (error) {
      alert(`Failed to confirm account: ${error}`);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-green-50">
      <div className="bg-white p-8 rounded-lg shadow-md w-96">
        <h1 className="text-3xl font-bold mb-6 text-center text-green-800">PlantApp</h1>
        <form className="space-y-4" onSubmit={handleSubmit}>
          <div className="space-y-2">
            <Label htmlFor="email" className="text-green-700">Correo electrónico</Label>
            <Input
                id="email"
                type="email"
                required
                className="border-green-300 focus:border-green-500 focus:ring-green-500 text-center"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                readOnly
            />
          </div>
          <div className="space-y-2">
            <Label htmlFor="password" className="text-green-700">Codigo de confirmacion</Label>
            <Input
                id="password"
                type="text"
                required
                className="border-green-300 focus:border-green-500 focus:ring-green-500 text-center"
                value={confirmationCode}
                onChange={(e) => setConfirmationCode(e.target.value)}
            />
          </div>
          <Button type="submit" className="w-full bg-green-600 hover:bg-green-700 text-white">
            Enviar
          </Button>
        </form>
      </div>
    </div>
  )
}