*set var FiberTag=SectionID
*set var SelectedSteelMaterial=tcl(FindMaterialNumber *MatProp(Steel_material) *DomainNum)
*set var MaterialExists=tcl(CheckUsedMaterials *SelectedSteelMaterial)
*if(MaterialExists==-1)
*loop materials *NotUsed
*set var MaterialID=tcl(FindMaterialNumber *Matprop(0) *DomainNum)
*if(SelectedSteelMaterial==MaterialID)
*if(strcmp(MatProp(Material:),"Steel01")==0)
*include ..\Materials\Uniaxial\Steel01.bas
*elseif(strcmp(MatProp(Material:),"Steel02")==0)
*include ..\Materials\Uniaxial\Steel02.bas
*elseif(strcmp(MatProp(Material:),"ReinforcingSteel")==0)
*include ..\Materials\Uniaxial\ReinforcingSteel.bas
*elseif(strcmp(MatProp(Material:),"RambergOsgoodSteel")==0)
*include ..\Materials\Uniaxial\RambergOsgoodSteel.bas
*elseif(strcmp(MatProp(Material:),"Hysteretic")==0)
*include ..\Materials\Uniaxial\Hysteretic.bas
*elseif(strcmp(MatProp(Material:),"MinMax")==0)
*include ..\Materials\Uniaxial\MinMax.bas
*else
*MessageBox Error: Unsupported Rebar material for Fiber Section
*endif
*set var dummy=tcl(AddUsedMaterials *SelectedSteelMaterial)
*break
*endif
*end materials
*endif
*# ------------------------FIBER definition--------------------
*set var h=MatProp(Height_h,real)
*set var tw=MatProp(Web_thickness_tw,real)
*set var b=MatProp(Flange_width_b,real)
*set var tf=MatProp(Flange_thickness_tf,real)
*set var angle=MatProp(Rotation_angle,real)
*set var E=MatProp(Young_modulus,real)
*set var JG=MatProp(Torsional_stiffness,real)
*# Area of the section is *MatProp(Cross_section_area,real)
*format "%d"
section fiberSecThermal *FiberTag *\
*format "%g"
-GJ *JG *\
 {
# Top flange
# patch rect $matTag $numSubdivIJ $numSubdivJK $yI $zI $yJ $zJ $yK $zK $yL $zL
*set var zdivision=MatProp(Flange_Z_fibers,int)
*set var ydivision=MatProp(Flange_Y_fibers,int)
*set var Iy=tcl(GetTopFlangeIy *h *b *tf *angle)
*set var Iz=tcl(GetTopFlangeIz *h *b *tf *angle)
*set var Jy=tcl(GetTopFlangeJy *h *b *tf *angle)
*set var Jz=tcl(GetTopFlangeJz *h *b *tf *angle)
*set var Ky=tcl(GetTopFlangeKy *h *b *tf *angle)
*set var Kz=tcl(GetTopFlangeKz *h *b *tf *angle)
*set var Ly=tcl(GetTopFlangeLy *h *b *tf *angle)
*set var Lz=tcl(GetTopFlangeLz *h *b *tf *angle)
*format "%6d%6d%6d%10.6f%10.6f%10.6f%10.6f%10.6f%10.6f%10.6f%10.6f"
patch quad *SelectedSteelMaterial *ydivision *zdivision *Iy *Iz *Jy *Jz *Ky *Kz *Ly *Lz
# Web
*set var zdivision=MatProp(Web_Z_fibers,int)
*set var ydivision=MatProp(Web_Y_fibers,int)
*set var Iy=tcl(GetWebIy *h *tw *tf *angle)
*set var Iz=tcl(GetWebIz *h *tw *tf *angle)
*set var Jy=tcl(GetWebJy *h *tw *tf *angle)
*set var Jz=tcl(GetWebJz *h *tw *tf *angle)
*set var Ky=tcl(GetWebKy *h *tw *tf *angle)
*set var Kz=tcl(GetWebKz *h *tw *tf *angle)
*set var Ly=tcl(GetWebLy *h *tw *tf *angle)
*set var Lz=tcl(GetWebLz *h *tw *tf *angle)
*format "%6d%6d%6d%10.6f%10.6f%10.6f%10.6f%10.6f%10.6f%10.6f%10.6f"
patch quad *SelectedSteelMaterial *ydivision *zdivision *Iy *Iz *Jy *Jz *Ky *Kz *Ly *Lz

*if(strcmp(Matprop(Cross_section),"Stiffened_I_Section_1")==0 && MatProp(Plate_t,real) > 0)
# Left stiffening plate
*set var pt = MatProp(Plate_t,real)
*set var pl = MatProp(Plate_l,real)
*set var zdivision=MatProp(Plate_Z_fibers,int)
*set var ydivision=MatProp(Plate_Y_fibers,int)
*set var Iy=tcl(GetLeftPlateIy *pl *b *pt *angle)
*set var Iz=tcl(GetLeftPlateIz *pl *b *pt *angle)
*set var Jy=tcl(GetLeftPlateJy *pl *b *pt *angle)
*set var Jz=tcl(GetLeftPlateJz *pl *b *pt *angle)
*set var Ky=tcl(GetLeftPlateKy *pl *b *pt *angle)
*set var Kz=tcl(GetLeftPlateKz *pl *b *pt *angle)
*set var Ly=tcl(GetLeftPlateLy *pl *b *pt *angle)
*set var Lz=tcl(GetLeftPlateLz *pl *b *pt *angle)
*format "%6d%6d%6d%10.6f%10.6f%10.6f%10.6f%10.6f%10.6f%10.6f%10.6f"
patch quad *SelectedSteelMaterial *ydivision *zdivision *Iy *Iz *Jy *Jz *Ky *Kz *Ly *Lz
# Right stiffening plate
*set var Iy=tcl(GetRightPlateIy *pl *b *pt *angle)
*set var Iz=tcl(GetRightPlateIz *pl *b *pt *angle)
*set var Jy=tcl(GetRightPlateJy *pl *b *pt *angle)
*set var Jz=tcl(GetRightPlateJz *pl *b *pt *angle)
*set var Ky=tcl(GetRightPlateKy *pl *b *pt *angle)
*set var Kz=tcl(GetRightPlateKz *pl *b *pt *angle)
*set var Ly=tcl(GetRightPlateLy *pl *b *pt *angle)
*set var Lz=tcl(GetRightPlateLz *pl *b *pt *angle)
*format "%6d%6d%6d%10.6f%10.6f%10.6f%10.6f%10.6f%10.6f%10.6f%10.6f"
patch quad *SelectedSteelMaterial *ydivision *zdivision *Iy *Iz *Jy *Jz *Ky *Kz *Ly *Lz
*endif 
# Bottom flange
*set var zdivision=MatProp(Flange_Z_fibers,int)
*set var ydivision=MatProp(Flange_Y_fibers,int)
*set var Iy=tcl(GetBotFlangeIy *h *b *tf *angle)
*set var Iz=tcl(GetBotFlangeIz *h *b *tf *angle)
*set var Jy=tcl(GetBotFlangeJy *h *b *tf *angle)
*set var Jz=tcl(GetBotFlangeJz *h *b *tf *angle)
*set var Ky=tcl(GetBotFlangeKy *h *b *tf *angle)
*set var Kz=tcl(GetBotFlangeKz *h *b *tf *angle)
*set var Ly=tcl(GetBotFlangeLy *h *b *tf *angle)
*set var Lz=tcl(GetBotFlangeLz *h *b *tf *angle)
*format "%6d%6d%6d%10.6f%10.6f%10.6f%10.6f%10.6f%10.6f%10.6f%10.6f"
patch quad *SelectedSteelMaterial *ydivision *zdivision *Iy *Iz *Jy *Jz *Ky *Kz *Ly *Lz
}
