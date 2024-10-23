import React from 'react';
import './App.css';
import Signup from "./app/sign-up";
import Login from "./app/login";
import ConfirmUserPage from "./app/confirmation-code";
import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";
import MyPlants from "./app/plant-app";


const App = () => {
    const isAuthenticated = () => {
        const accessToken = sessionStorage.getItem("accessToken");
        return !!accessToken;
    };

    return (
        <div className="App">
            <BrowserRouter>
                <Routes>
                    <Route
                        path="/"
                        element={
                            isAuthenticated() ? (
                                <Navigate replace to="/home"/>
                            ) : (
                                <Navigate replace to="/login"/>
                            )
                        }
                    />
                    <Route path="/login" element={<Login/>}/>
                    <Route path="/signup" element={<Signup/>}/>
                    <Route path="/confirm" element={<ConfirmUserPage/>}/>
                    <Route
                        path="/home"
                        element={
                            isAuthenticated() ? <MyPlants/> : <Navigate replace to="/login"/>
                        }
                    />
                </Routes>
            </BrowserRouter>
    </div>
    );
};


export default App;
