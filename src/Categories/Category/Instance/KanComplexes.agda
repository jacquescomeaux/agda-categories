

-- The Category of Algebraic Kan Complexes
module Categories.Category.Instance.KanComplexes where

open import Level

open import Function using (_$_)
open import Data.Product using (Σ; _,_; proj₁)

open import Categories.Category
open import Categories.Category.SubCategory
open import Categories.Category.Instance.SimplicialSet

import Categories.Category.Instance.SimplicialSet.Properties as ΔSetₚ

import Categories.Morphism.Reasoning as MR

module _ (o ℓ : Level) where
  open Category (SimplicialSet o ℓ)
  open ΔSetₚ o ℓ
  open IsKanComplex
  open Equiv
  open MR (SimplicialSet o ℓ)
  
  -- As we are working with Algebraic Kan Complexes, maps between two Kan Complexes ought
  -- to take the chosen filler in 'X' to the chosen filler in 'Y'.
  PreservesFiller : ∀ {X Y : ΔSet} → IsKanComplex X → IsKanComplex Y → (X ⇒ Y) → Set (o ⊔ ℓ)
  PreservesFiller {X} {Y} X-Kan Y-Kan f = ∀ {n} {k} → (i : Λ[ n , k ] ⇒ X) → (f ∘ filler X-Kan {n} i) ≈ filler Y-Kan (f ∘ i)  

  KanComplexes : Category (suc o ⊔ suc ℓ) (o ⊔ ℓ ⊔ (o ⊔ ℓ)) (o ⊔ ℓ)
  KanComplexes = SubCategory (SimplicialSet o ℓ) {I = Σ ΔSet IsKanComplex} $ record
    { U = proj₁
    ; R = λ { {X , X-Kan} {Y , Y-Kan} f → PreservesFiller X-Kan Y-Kan f }
    ; Rid = λ { {X , X-Kan} i → begin
        id ∘ filler X-Kan i   ≈⟨ identityˡ {f = filler X-Kan i} ⟩
        filler X-Kan i        ≈˘⟨ filler-cong X-Kan (identityˡ {f = i}) ⟩
        filler X-Kan (id ∘ i) ∎
      }
    ; _∘R_ = λ { {X , X-Kan} {Y , Y-Kan} {Z , Z-Kan} {f} {g} f-preserves g-preserves i → begin
        (f ∘ g) ∘ filler X-Kan i ≈⟨ assoc {f = filler X-Kan i} {g = g} {h = f} ⟩
        f ∘ (g ∘ filler X-Kan i) ≈⟨ ∘-resp-≈ʳ {f = (g ∘ filler X-Kan i)} {h = filler Y-Kan (g ∘ i)} {g = f} (g-preserves i) ⟩
        f ∘ filler Y-Kan (g ∘ i) ≈⟨ f-preserves (g ∘ i) ⟩
        filler Z-Kan (f ∘ g ∘ i) ≈˘⟨ filler-cong Z-Kan (assoc {f = i} {g = g} {h = f}) ⟩
        filler Z-Kan ((f ∘ g) ∘ i) ∎
      }
    }
    where
      open HomReasoning
