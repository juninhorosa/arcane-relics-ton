import React, { useEffect, useRef } from 'react';
import * as THREE from 'three';

/**
 * Renderiza uma Relíquia Arcana em 3D usando Three.js puro para máxima performance.
 */
export const Arcane3D: React.FC = () => {
  const containerRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!containerRef.current) return;

    const scene = new THREE.Scene();
    const camera = new THREE.PerspectiveCamera(75, 1, 0.1, 1000);
    const renderer = new THREE.WebGLRenderer({ alpha: true, antialias: true });
    
    const size = 300;
    renderer.setSize(size, size);
    containerRef.current.appendChild(renderer.domElement);

    // Geometria de um cristal (Octaedro)
    const geometry = new THREE.OctahedronGeometry(1.5, 0);
    const material = new THREE.MeshPhongMaterial({
      color: 0xD4AF37, // Arcane Gold
      shininess: 100,
      transparent: true,
      opacity: 0.8,
      wireframe: true,
    });
    
    const crystal = new THREE.Mesh(geometry, material);
    scene.add(crystal);

    // Iluminação
    const light = new THREE.PointLight(0xD4AF37, 10, 100);
    light.position.set(2, 2, 5);
    scene.add(light);
    scene.add(new THREE.AmbientLight(0x404040));

    camera.position.z = 4;

    const animate = () => {
      requestAnimationFrame(animate);
      crystal.rotation.y += 0.01;
      crystal.rotation.z += 0.005;
      
      // Efeito de flutuação
      crystal.position.y = Math.sin(Date.now() * 0.002) * 0.2;
      
      renderer.render(scene, camera);
    };

    animate();

    return () => {
      renderer.dispose();
      if (containerRef.current) containerRef.current.removeChild(renderer.domElement);
    };
  }, []);

  return (
    <div className="relative flex justify-center items-center h-64 w-full">
      <div ref={containerRef} className="z-20 drop-shadow-[0_0_30px_rgba(212,175,55,0.5)]" />
    </div>
  );
};