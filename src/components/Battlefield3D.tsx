import React, { useEffect, useRef } from 'react';
import * as THREE from 'three';

interface Battlefield3DProps {
  isActive: boolean;
  healthPercent: number;
}

export const Battlefield3D: React.FC<Battlefield3DProps> = ({ isActive, healthPercent }) => {
  const containerRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!containerRef.current) return;

    const scene = new THREE.Scene();
    const camera = new THREE.PerspectiveCamera(75, 1, 0.1, 1000);
    const renderer = new THREE.WebGLRenderer({ alpha: true, antialias: true });
    
    renderer.setSize(containerRef.current.clientWidth, 350);
    containerRef.current.appendChild(renderer.domElement);

    // Relíquia (Dodecaedro)
    const geometry = new THREE.DodecahedronGeometry(2, 0);
    const material = new THREE.MeshPhongMaterial({
      color: isActive ? 0xff4444 : 0x4444ff,
      wireframe: true,
      emissive: isActive ? 0x770000 : 0x000077,
      emissiveIntensity: 1,
    });
    
    const relic = new THREE.Mesh(geometry, material);
    scene.add(relic);

    // Anéis de Cerco
    const ringGeo = new THREE.TorusGeometry(3.5, 0.05, 16, 100);
    const ringMat = new THREE.MeshBasicMaterial({ color: 0xD4AF37, transparent: true, opacity: 0.4 });
    const ring = new THREE.Mesh(ringGeo, ringMat);
    ring.rotation.x = Math.PI / 2;
    scene.add(ring);

    // Iluminação
    const light = new THREE.PointLight(isActive ? 0xff0000 : 0x0000ff, 15, 100);
    light.position.set(2, 5, 5);
    scene.add(light);
    scene.add(new THREE.AmbientLight(0x222222));

    camera.position.z = 8;
    camera.position.y = 2;
    camera.lookAt(0, 0, 0);

    const animate = () => {
      requestAnimationFrame(animate);
      
      // Velocidade de rotação aumenta conforme a vida diminui
      const speedMult = 1 + (1 - healthPercent / 100) * 3;
      relic.rotation.y += 0.01 * speedMult;
      relic.rotation.x += 0.005;
      
      ring.rotation.z -= 0.005;
      
      // Efeito de instabilidade se ativo
      if (isActive) {
        relic.position.x = (Math.random() - 0.5) * 0.1 * (1 - healthPercent / 100);
      }

      renderer.render(scene, camera);
    };

    animate();

    return () => {
      renderer.dispose();
      if (containerRef.current) containerRef.current.removeChild(renderer.domElement);
    };
  }, [isActive, healthPercent]);

  return (
    <div className="relative w-full h-[350px] flex justify-center items-center">
      <div ref={containerRef} className="w-full max-w-md" />
      {/* Ground Shadow */}
      <div className="absolute bottom-10 w-48 h-6 bg-black/40 blur-xl rounded-[100%] scale-x-150" />
    </div>
  );
};