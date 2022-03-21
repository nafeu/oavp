String[] PARAM_FIELDS = {
  "paramA",
  "paramB",
  "paramC",
  "paramD",
  "paramE"
};

public class OavpVariable {
  public String name = "";

  public int x = 0; public float xMod = 0; public float xIter = 0; public String xModType = "none"; public String xIterFunc = "none";
  public int xr = 0; public float xrMod = 0; public float xrIter = 0; public String xrModType = "none"; public String xrIterFunc = "none";
  public int y = 0; public float yMod = 0; public float yIter = 0; public String yModType = "none"; public String yIterFunc = "none";
  public int yr = 0; public float yrMod = 0; public float yrIter = 0; public String yrModType = "none"; public String yrIterFunc = "none";
  public int z = 0; public float zMod = 0; public float zIter = 0; public String zModType = "none"; public String zIterFunc = "none";
  public int zr = 0; public float zrMod = 0; public float zrIter = 0; public String zrModType = "none"; public String zrIterFunc = "none";
  public float w = 100; public float wMod = 0; public float wIter = 0; public String wModType = "none"; public String wIterFunc = "none";
  public float h = 100; public float hMod = 0; public float hIter = 0; public String hModType = "none"; public String hIterFunc = "none";
  public float l = 0; public float lMod = 0; public float lIter = 0; public String lModType = "none"; public String lIterFunc = "none";
  public float s = 100; public float sMod = 0; public float sIter = 0; public String sModType = "none"; public String sIterFunc = "none";
  public color strokeColor; public float strokeColorMod = 0; public float strokeColorIter = 0; public String strokeColorModType = "none"; public String strokeColorIterFunc = "none";
  public color fillColor; public float fillColorMod = 0; public float fillColorIter = 0; public String fillColorModType = "none"; public String fillColorIterFunc = "none";
  public float strokeWeight = 2; public float strokeWeightMod = 0; public float strokeWeightIter = 0; public String strokeWeightModType = "none"; public String strokeWeightIterFunc = "none";
  public float paramA = 0; public float paramAMod = 0; public float paramAIter = 0; public String paramAModType = "none"; public String paramAIterFunc = "none";
  public float paramB = 0; public float paramBMod = 0; public float paramBIter = 0; public String paramBModType = "none"; public String paramBIterFunc = "none";
  public float paramC = 0; public float paramCMod = 0; public float paramCIter = 0; public String paramCModType = "none"; public String paramCIterFunc = "none";
  public float paramD = 0; public float paramDMod = 0; public float paramDIter = 0; public String paramDModType = "none"; public String paramDIterFunc = "none";
  public float paramE = 0; public float paramEMod = 0; public float paramEIter = 0; public String paramEModType = "none"; public String paramEIterFunc = "none";
  public int modDelay = 0;
  public int i = 1;

  public HashMap<String, String> paramLabels;
  public HashMap<String, Object> customAttrs;

  public List<String> variations;
  public int variation = 0;

  OavpVariable() {
    this.paramLabels = new HashMap<String, String>();
    paramLabels.put("paramA", "-"); paramLabels.put("paramB", "-"); paramLabels.put("paramC", "-"); paramLabels.put("paramD", "-"); paramLabels.put("paramE", "-");
    this.customAttrs = new HashMap<String, Object>();
    this.variations = new ArrayList();
    this.variations("default");
  }

  OavpVariable(String name) {
    this.name = name;
    this.paramLabels = new HashMap<String, String>();
    paramLabels.put("paramA", "-"); paramLabels.put("paramB", "-"); paramLabels.put("paramC", "-"); paramLabels.put("paramD", "-"); paramLabels.put("paramE", "-");
    this.customAttrs = new HashMap<String, Object>();
    this.variations = new ArrayList();
    this.variations("default");
  }

  public String getParamLabel(String paramKey) {
    return this.paramLabels.get(paramKey);
  }

  public OavpVariable params(String ...paramNames) {
    String[] paramKeys = { "paramA", "paramB", "paramC", "paramD", "paramE" };
    int index = 0;
    for (String paramName : paramNames) {
      this.paramLabels.replace(paramKeys[index], paramName);
      index++;
    }
    return this;
  }

  public OavpVariable set(String prop, Object input) {
    Set<String> fields = this.getDeclaredFields();
    try {
      if (fields.contains(prop)) {
        Field field = this.getClass().getDeclaredField(prop);
        if (prop == "variation") {
          field.set(this, this.getVariationIndex(input));
        } else {
          field.set(this, input);
        }
      } else if (this.customAttrs.containsKey(prop)) {
        this.customAttrs.replace(prop, input);
      } else {
        this.customAttrs.put(prop, input);
      }
    } catch (Exception e) {
      e.printStackTrace();
    }

    return this;
  }

  public int getVariationIndex(Object option) {
    if (this.variations.contains((String) option)) {
      return this.variations.indexOf((String) option);
    } else {
      return 0;
    }
  }

  public OavpVariable variation(String option) {
    if (variations.contains(option)) {
      this.variation = variations.indexOf(option);
    } else {
      this.variation = 0;
    }
    return this;
  }

  public OavpVariable variations(String ...options) {
    for (String option: options) {
      this.variations.add(option);
    }
    return this;
  }

  public float val(String prop) {
    try {
      Field field = this.getClass().getDeclaredField(prop);
      Field fieldMod = this.getClass().getDeclaredField(prop + "Mod");
      Field fieldModType = this.getClass().getDeclaredField(prop + "ModType");

      if (field.get(this).getClass() == Integer.class) {
        int baseValue = (int) field.get(this);
        float mod = (float) fieldMod.get(this);
        float modMultiplier = getMod((String) fieldModType.get(this), this.modDelay);
        float output = baseValue + (mod * modMultiplier);
        return output;
      }

      if (field.get(this).getClass() == Float.class) {
        float baseValue = (float) field.get(this);
        float mod = (float) fieldMod.get(this);
        float modMultiplier = getMod((String) fieldModType.get(this), this.modDelay);
        float output = baseValue + (mod * modMultiplier);
        return output;
      }
    } catch (Exception e) {
      e.printStackTrace();
    }
    return 0.0;
  }

  public float val(String prop, int iteration) {
    try {
      Field field = this.getClass().getDeclaredField(prop);
      Field fieldMod = this.getClass().getDeclaredField(prop + "Mod");
      Field fieldModType = this.getClass().getDeclaredField(prop + "ModType");
      Field fieldIter = this.getClass().getDeclaredField(prop + "Iter");
      Field fieldIterFunc = this.getClass().getDeclaredField(prop + "IterFunc");

      if (field.get(this).getClass() == Integer.class) {
        int baseValue = (int) field.get(this);
        float mod = (float) fieldMod.get(this);
        float iter = (float) fieldIter.get(this);
        float modMultiplier = getMod(
          (String) fieldModType.get(this),
          iteration > 0 ? iteration : this.modDelay
        );
        float iterMultiplier = getFunc((String) fieldIterFunc.get(this), iteration);
        float output = baseValue + (mod * modMultiplier) + (iter * iterMultiplier);
        // println("i_baseValue: ", baseValue);
        // println("i_iter: ", iter);
        // println("i_iterMultiplier: ", iterMultiplier);
        return output;
      }

      if (field.get(this).getClass() == Float.class) {
        float baseValue = (float) field.get(this);
        float mod = (float) fieldMod.get(this);
        float modMultiplier = getMod((String) fieldModType.get(this), this.modDelay);
        float iter = (float) fieldIter.get(this);
        float iterMultiplier = getFunc((String) fieldIterFunc.get(this), iteration);
        float output = baseValue + (mod * modMultiplier) + (iter * iterMultiplier);
        // println("f_baseValue: ", baseValue);
        // println("f_iter: ", iter);
        // println("f_iterMultiplier: ", iterMultiplier);
        return output;
      }
    } catch (Exception e) {
      e.printStackTrace();
    }
    return 0.0;
  }

  public OavpVariable s(float input) {
    this.s = input;
    return this;
  }

  public OavpVariable sMod(float input) {
    this.sMod = input;
    return this;
  }

  public OavpVariable sModType(String input) {
    this.sModType = input;
    return this;
  }

  public OavpVariable sIter(float input) {
    this.sIter = input;
    return this;
  }

  public OavpVariable sIterFunc(String input) {
    this.sIterFunc = input;
    return this;
  }

  public OavpVariable strokeWeight(float input) {
    this.strokeWeight = input;
    return this;
  }

  public OavpVariable strokeWeightMod(float input) {
    this.strokeWeightMod = input;
    return this;
  }

  public OavpVariable strokeWeightModType(String input) {
    this.strokeWeightModType = input;
    return this;
  }

  public OavpVariable strokeWeightIter(float input) {
    this.strokeWeightIter = input;
    return this;
  }

  public OavpVariable strokeWeightIterFunc(String input) {
    this.strokeWeightIterFunc = input;
    return this;
  }

  public OavpVariable w(float input) {
    this.w = input;
    return this;
  }

  public OavpVariable wMod(float input) {
    this.wMod = input;
    return this;
  }

  public OavpVariable wModType(String input) {
    this.wModType = input;
    return this;
  }

  public OavpVariable wIter(float input) {
    this.wIter = input;
    return this;
  }

  public OavpVariable wIterFunc(String input) {
    this.wIterFunc = input;
    return this;
  }

  public OavpVariable h(float input) {
    this.h = input;
    return this;
  }

  public OavpVariable hMod(float input) {
    this.hMod = input;
    return this;
  }

  public OavpVariable hModType(String input) {
    this.hModType = input;
    return this;
  }

  public OavpVariable hIter(float input) {
    this.hIter = input;
    return this;
  }

  public OavpVariable hIterFunc(String input) {
    this.hIterFunc = input;
    return this;
  }

  public OavpVariable l(float input) {
    this.l = input;
    return this;
  }

  public OavpVariable lMod(float input) {
    this.lMod = input;
    return this;
  }

  public OavpVariable lModType(String input) {
    this.lModType = input;
    return this;
  }

  public OavpVariable lIter(float input) {
    this.lIter = input;
    return this;
  }

  public OavpVariable lIterFunc(String input) {
    this.lIterFunc = input;
    return this;
  }

  public OavpVariable x(int input) {
    this.x = input;
    return this;
  }

  public OavpVariable xMod(float input) {
    this.xMod = input;
    return this;
  }

  public OavpVariable xModType(String input) {
    this.xModType = input;
    return this;
  }

  public OavpVariable xIter(float input) {
    this.xIter = input;
    return this;
  }

  public OavpVariable xIterFunc(String input) {
    this.xIterFunc = input;
    return this;
  }

  public OavpVariable xr(int input) {
    this.xr = input;
    return this;
  }

  public OavpVariable xrMod(float input) {
    this.xrMod = input;
    return this;
  }

  public OavpVariable xrModType(String input) {
    this.xrModType = input;
    return this;
  }

  public OavpVariable xrIter(float input) {
    this.xrIter = input;
    return this;
  }

  public OavpVariable xrIterFunc(String input) {
    this.xrIterFunc = input;
    return this;
  }

  public OavpVariable y(int input) {
    this.y = input;
    return this;
  }

  public OavpVariable yMod(float input) {
    this.yMod = input;
    return this;
  }

  public OavpVariable yModType(String input) {
    this.yModType = input;
    return this;
  }

  public OavpVariable yIter(float input) {
    this.yIter = input;
    return this;
  }

  public OavpVariable yIterFunc(String input) {
    this.yIterFunc = input;
    return this;
  }

  public OavpVariable yr(int input) {
    this.yr = input;
    return this;
  }

  public OavpVariable yrMod(float input) {
    this.yrMod = input;
    return this;
  }

  public OavpVariable yrModType(String input) {
    this.yrModType = input;
    return this;
  }

  public OavpVariable yrIter(float input) {
    this.yrIter = input;
    return this;
  }

  public OavpVariable yrIterFunc(String input) {
    this.yrIterFunc = input;
    return this;
  }

  public OavpVariable z(int input) {
    this.z = input;
    return this;
  }

  public OavpVariable zMod(float input) {
    this.zMod = input;
    return this;
  }

  public OavpVariable zModType(String input) {
    this.zModType = input;
    return this;
  }

  public OavpVariable zIter(float input) {
    this.zIter = input;
    return this;
  }

  public OavpVariable zIterFunc(String input) {
    this.zIterFunc = input;
    return this;
  }

  public OavpVariable zr(int input) {
    this.zr = input;
    return this;
  }

  public OavpVariable zrMod(float input) {
    this.zrMod = input;
    return this;
  }

  public OavpVariable zrModType(String input) {
    this.zrModType = input;
    return this;
  }

  public OavpVariable zrIter(float input) {
    this.zrIter = input;
    return this;
  }

  public OavpVariable zrIterFunc(String input) {
    this.zrIterFunc = input;
    return this;
  }

  public OavpVariable strokeColor(color input) {
    this.strokeColor = input;
    return this;
  }

  public OavpVariable strokeColorMod(float input) {
    this.strokeColorMod = input;
    return this;
  }

  public OavpVariable strokeColorModType(String input) {
    this.strokeColorModType = input;
    return this;
  }

  public OavpVariable strokeColorIter(float input) {
    this.strokeColorIter = input;
    return this;
  }

  public OavpVariable strokeColorIterFunc(String input) {
    this.strokeColorIterFunc = input;
    return this;
  }

  public OavpVariable fillColor(color input) {
    this.fillColor = input;
    return this;
  }

  public OavpVariable fillColorMod(float input) {
    this.fillColorMod = input;
    return this;
  }

  public OavpVariable fillColorModType(String input) {
    this.fillColorModType = input;
    return this;
  }

  public OavpVariable fillColorIter(float input) {
    this.fillColorIter = input;
    return this;
  }

  public OavpVariable fillColorIterFunc(String input) {
    this.fillColorIterFunc = input;
    return this;
  }

  public OavpVariable paramAMod(float input) {
    this.paramAMod = input;
    return this;
  }

  public OavpVariable paramAModType(String input) {
    this.paramAModType = input;
    return this;
  }

  public OavpVariable paramAIter(float input) {
    this.paramAIter = input;
    return this;
  }

  public OavpVariable paramAIterFunc(String input) {
    this.paramAIterFunc = input;
    return this;
  }

  public OavpVariable modDelay(int input) {
    this.modDelay = input;
    return this;
  }

  public OavpVariable i(int input) {
    this.i = input;
    return this;
  }

  public String getVariation() {
    return this.variations.get(this.variation);
  }

  public boolean ofVariation(String input) {
    return this.variations.get(this.variation).contains(input);
  }

  public color strokeColor() {
    return this.strokeColorMod == 0 ? this.strokeColor : opacity(this.strokeColor, (map(this.strokeColorMod, 0, 200, 0, 20) * getMod(this.strokeColorModType, 0)));
  }

  public color fillColor() {
    return this.fillColorMod == 0 ? this.fillColor : opacity(this.fillColor, (map(this.fillColorMod, 0, 200, 0, 20) * getMod(this.fillColorModType, 0)));
  }

  private Object get(String fieldName) {
    OavpVariable activeVariable = objects.getActiveVariable();
    try {
      Field field = activeVariable.getClass().getDeclaredField(fieldName);
      return field.get(activeVariable);
    } catch (Exception e) {
      e.printStackTrace();
    }
    return null;
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder();

    Class<?> thisClass = null;
    try {
        thisClass = Class.forName(this.getClass().getName());

        Field[] aClassFields = thisClass.getDeclaredFields();
        // sb.append(this.getClass().getSimpleName() + " [ ");
        // for(Field f : aClassFields){
        //     String fName = f.getName();
        //     sb.append("(" + f.getType() + ") " + fName + " = " + f.get(this) + ", ");
        // }
        // sb.append("]");
        for(Field f : aClassFields){
            String fName = f.getName();
            sb.append(fName + ", ");
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    return sb.toString();
  }

  public Set<String> getDeclaredFields() {
    Set<String> output = new HashSet<String>();
    Class<?> thisClass = null;

    try {
        thisClass = Class.forName(this.getClass().getName());
        Field[] aClassFields = thisClass.getDeclaredFields();
        for(Field f : aClassFields){
            String fName = f.getName();
            output.add(fName);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    return output;
  }
}