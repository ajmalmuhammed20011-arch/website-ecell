import { useRef } from 'react';
import { Canvas, useFrame } from '@react-three/fiber';
import { Float, MeshDistortMaterial, Sparkles } from '@react-three/drei';
import type { Mesh } from 'three';
function SparkOrb() {
  const ref = useRef<Mesh>(null!);
  useFrame((state, delta) => { ref.current.rotation.y += delta * .2; ref.current.rotation.x = Math.sin(state.clock.elapsedTime * .3) * .13; });
  return <Float speed={1.2} rotationIntensity={.25} floatIntensity={.6}><mesh ref={ref} scale={1.19}><icosahedronGeometry args={[1, 5]} /><MeshDistortMaterial color="#3564b0" roughness={.16} metalness={.82} distort={.33} speed={1.55} emissive="#102c6b" emissiveIntensity={.27} /></mesh><mesh scale={1.205}><icosahedronGeometry args={[1, 2]} /><meshBasicMaterial color="#a7d8ff" transparent opacity={.12} wireframe /></mesh></Float>;
}
export default function HeroScene() { return <Canvas camera={{ position: [0, 0, 4.4], fov: 40 }} dpr={[1, 1.5]} gl={{ alpha: true, antialias: true }}><ambientLight intensity={1.25} /><pointLight position={[2, 3, 4]} intensity={12} color="#c4e7ff" /><pointLight position={[-3, -2, 0]} intensity={8} color="#376aff" /><SparkOrb /><Sparkles count={42} scale={6} size={1.5} speed={.17} color="#a9ccff" /></Canvas>; }
